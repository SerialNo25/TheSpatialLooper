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
            // root
            setupRootEntity()
            setupHands()
            content.add(rootEntity)
        
            
            // setup hands as loopTriggers
            guard let leftViewAttachment = attachments.entity(for: AttachmendIdentifier.leftLoopRecordingView) else {fatalError("leftLoopRecordingView attachment not found. Ensure the attachment is linked.")}
            guard let rightViewAttachment = attachments.entity(for: AttachmendIdentifier.rightLoopRecordingView) else {fatalError("rightLoopRecordingView attachment not found. Ensure the attachment is linked.")}
            setUpLoopTrigger(viewAttachmentEntity: leftViewAttachment, triggerName: "leftHand", chirality: .left)
            setUpLoopTrigger(viewAttachmentEntity: rightViewAttachment, triggerName: "rightHand", chirality: .right)
            
            
            
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
                LoopRecordingView(name: "left")
            }
            Attachment(id: AttachmendIdentifier.rightLoopRecordingView) {
                LoopRecordingView(name: "right")
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
    
    func setUpLoopTrigger(viewAttachmentEntity: ViewAttachmentEntity, triggerName: String, chirality: HandAnchor.Chirality) {
        let loopTrigger = LoopTriggerEntity()
        let recordingViewReferenceJoint = HandSkeleton.JointName.wrist
        loopTrigger.setLoopRecordingView(loopRecordingView: viewAttachmentEntity)
        loopTrigger.setName(name: triggerName)
        loopTrigger.attachToHand(handReferenceEntity: HandTrackingManager.shared.getJoint(chirality: chirality, joint: recordingViewReferenceJoint))
        
        guard loopTrigger.validateSetup() else { fatalError("Setup of: \(triggerName) failed. Ensure configration is complete")}
    }
    
    func setupRootEntity() {
        let newRoot = Entity()
        newRoot.name = "RootEntity"
        rootEntity = newRoot
    }
}

