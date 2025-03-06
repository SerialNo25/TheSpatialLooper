//
//  PerformanceRealityView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

import RealityKit
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
            setupRootEntity()
            setupHands()
            content.add(rootEntity)
            
            
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

