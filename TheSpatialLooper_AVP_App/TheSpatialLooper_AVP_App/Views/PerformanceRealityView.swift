//
//  PerformanceRealityView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

import RealityKit
import ARKit
import SwiftUI

@MainActor
struct PerformanceRealityView: View {
    
    @Environment(AppState.self) private var appState
    @State private var rootEntity = Entity()
    
    private let leftTriggerEntity = LoopTriggerEntity(triggerName: "leftHand", chirality: .left)
    private let rightTriggerEntity = LoopTriggerEntity(triggerName: "rightHand", chirality: .right)
    
    @State private var collisionBeganSubscription: EventSubscription? = nil
    @State private var collisionEndedSubscription: EventSubscription? = nil
    
    
    
    // MARK: - Debug Tool
    // TODO: Remove
    func printEntityHierarchy(entity: Entity, indent: String = "") {
        // Print the current entity's name or description
        let entityName = entity.name.isEmpty ? "Unnamed Entity" : entity.name
        print("\(indent)\(entityName)")
        
        // Recursively print all children with increased indentation
        for child in entity.children {
            printEntityHierarchy(entity: child, indent: indent + "|  ")
        }
    }
    // MARK: - END Debug Tool
    
    
    
    var body: some View {
        RealityView { content, attachments in
            // MARK: - RV INIT
            // root setup
            setupRootEntity()
            setupHands()
            content.add(rootEntity)
            
            
            // setup loop triggers
            setupLoopTrigger(attachments: attachments, attachmentIdentifier: .leftLoopRecordingView, triggerEntity: leftTriggerEntity, horizontalAttachmentOffset: -0.07)
            setupLoopTrigger(attachments: attachments, attachmentIdentifier: .rightLoopRecordingView, triggerEntity: rightTriggerEntity, horizontalAttachmentOffset: 0.07)
            
            
            // setup loop sources:
            self.setupLoopSources(attachments: attachments)
            
            
            // setup trigger collisions
            collisionBeganSubscription = content.subscribe(to: CollisionEvents.Began.self) { collisionEvent in
                guard appState.looperActive else { return }
                collisionEvent.handleTriggerEvent()
            }
            
            collisionEndedSubscription = content.subscribe(to: CollisionEvents.Ended.self) { collisionEvent in
                guard appState.looperActive else { return }
                collisionEvent.handleTriggerEvent()
            }
            
            
            
            
            
            // DEBUG
            for contentEntity in content.entities {
                printEntityHierarchy(entity: contentEntity)
            }
            // END DEBUG
            
            
            
            
            Task {await ARKitSessionManager.shared.runSession()}
            Task {await HandTrackingManager.shared.processHandUpdates()}
            Task {await ObjectTrackingManager.shared.processAnchorUpdates()}
            
            
            
        } update: { update, attachments in
            // MARK: - RV UPDATE
            
        } attachments: {
            // MARK: - RV ATTACHMENTS
            Attachment(id: AttachmentIdentifier.leftLoopRecordingView) {
                LoopTriggerView(loopTriggerEntity: leftTriggerEntity, name: "left")
            }
            Attachment(id: AttachmentIdentifier.rightLoopRecordingView) {
                LoopTriggerView(loopTriggerEntity: rightTriggerEntity, name: "right")
            }
            
            // Tracks
            ForEach(GlobalConfig.LOOP_SOURCE_CONFIGURATIONS) { source in
                Attachment(id: source.id) {
                    SessionTrackView(track: LiveSessionManager.shared.tracksAscending[source.trackID])
                }
            }
            
        }
        // MARK: - SHUTDOWN TASKS
        .onDisappear {
            Task {
                ARKitSessionManager.shared.stopSession()
            }
        }
        
    }
    
    
    
    
    // MARK: - SETUP UTIL
    func setupHands() {
        let handContainer = Entity()
        handContainer.name = "HandContainer"
        
        for joint in HandTrackingManager.shared.joints.values { handContainer.addChild(joint) }
        
        rootEntity.addChild(handContainer)
    }
    
    func setupLoopTrigger(attachments: RealityViewAttachments, attachmentIdentifier: AttachmentIdentifier, triggerEntity: LoopTriggerEntity, horizontalAttachmentOffset: Float) {
        guard let viewAttachment = attachments.entity(for: attachmentIdentifier) else {fatalError("View attachment for \(triggerEntity.name) not found. Ensure the attachment is linked.")}
        triggerEntity.setLoopRecordingView(loopRecordingView: viewAttachment, horizontalAttachmentOffset: horizontalAttachmentOffset)
        guard triggerEntity.validateSetup() else { fatalError("Setup of: \(triggerEntity.name) failed. Ensure configration is complete")}
        // hands are attached to the hand directly. This replaces direct link to root entity
        triggerEntity.attachToHand()
    }
    
    func setupLoopSources(attachments: RealityViewAttachments) {
        for loopSourceConfig in GlobalConfig.LOOP_SOURCE_CONFIGURATIONS {
            let source = LoopSourceEntity(from: loopSourceConfig)
            guard let trackAttachment = attachments.entity(for: loopSourceConfig.id) else {fatalError("attachment for \(loopSourceConfig.id) not found. Ensure the attachment is linked.")}
            source.setSessionTrackView(from: loopSourceConfig, with: trackAttachment)
            guard source.validateSetup() else { fatalError("Setup of: \(source.name) failed. Ensure configration is complete")}
            rootEntity.addChild(source)
            
            // send the object to be tracked
            ObjectTrackingManager.shared.addLoopSource(loopSource: source, with: loopSourceConfig)
        }
    }
    
    
    func setupRootEntity() {
        let newRoot = Entity()
        newRoot.name = "RootEntity"
        rootEntity = newRoot
    }
}

enum AttachmentIdentifier {
    case leftLoopRecordingView
    case rightLoopRecordingView
}
