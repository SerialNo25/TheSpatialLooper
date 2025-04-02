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
        
            
            // setup hands as loopTriggers
            guard let leftViewAttachment = attachments.entity(for: AttachmendIdentifier.leftLoopRecordingView) else {fatalError("leftLoopRecordingView attachment not found. Ensure the attachment is linked.")}
            guard let rightViewAttachment = attachments.entity(for: AttachmendIdentifier.rightLoopRecordingView) else {fatalError("rightLoopRecordingView attachment not found. Ensure the attachment is linked.")}
            leftTriggerEntity.setLoopRecordingView(loopRecordingView: leftViewAttachment)
            rightTriggerEntity.setLoopRecordingView(loopRecordingView: rightViewAttachment)
            guard leftTriggerEntity.validateSetup() else { fatalError("Setup of: \(leftTriggerEntity.name) failed. Ensure configration is complete")}
            guard rightTriggerEntity.validateSetup() else { fatalError("Setup of: \(rightTriggerEntity.name) failed. Ensure configration is complete")}
            // hands are attached to the hand directly. This replaces direct link to root entity
            leftTriggerEntity.attachToHand()
            rightTriggerEntity.attachToHand()
            
            
            
            
            // MARK: TRACK SETUP
            // TrackTesting:
            let source1 = LoopSourceEntity(sourceName: "TestSource", track: LiveSessionManager.shared.tracksAscending[0],  boundingBoxX: 1, boundingBoxY: 0.1, boundingBoxZ: 0.5, boundingBoxOffsetZ: 0.1)
            guard let track1Attachment = attachments.entity(for: AttachmendIdentifier.track1) else {fatalError("leftLoopRecordingView attachment not found. Ensure the attachment is linked.")}
            source1.setSessionTrakView(sessionTrackView: track1Attachment, verticalOffset: 0.2)
            guard source1.validateSetup() else { fatalError("Setup of: \(source1.name) failed. Ensure configration is complete")}
            rootEntity.addChild(source1)
            
            
            
            
            
            // DEBUG
            for contentEntity in content.entities {
                printEntityHierarchy(entity: contentEntity)
            }
            // END DEBUG
            
            
            
            
            Task {await ARKitSessionManager.shared.runSession()}
            Task {await HandTrackingManager.shared.processHandUpdates()}
            
        } update: { update, attachments in
            // MARK: - RV UPDATE
            
        } attachments: {
            // MARK: - RV ATTACHMENTS
            Attachment(id: AttachmendIdentifier.leftLoopRecordingView) {
                LoopRecordingView(loopTriggerEntity: leftTriggerEntity, name: "left")
            }
            Attachment(id: AttachmendIdentifier.rightLoopRecordingView) {
                LoopRecordingView(loopTriggerEntity: rightTriggerEntity, name: "right")
            }
            
            // MARK: Tracks
            Attachment(id: AttachmendIdentifier.track1) {
                SessionTrackView(track: LiveSessionManager.shared.tracksAscending[0])
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
    
    func setupRootEntity() {
        let newRoot = Entity()
        newRoot.name = "RootEntity"
        rootEntity = newRoot
    }
}

