//
//  TheSpatialLooper_AVP_AppApp.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 04.03.2025.
//

import SwiftUI

@main
struct TheSpatialLooper_AVP_AppApp: App {
    
    private var appState = AppState.shared
    
    // MARK: - Entity Component System initialization
    init() {
        // MARK: COMPONENTS
        LoopTriggerEntityComponent.registerComponent()
        LoopSourceEntityComponent.registerComponent()
        FaceHeadsetComponent.registerComponent()
        
        // MARK: SYSTEMS
        FaceHeadsetSystem.registerSystem()
        LoopTriggerSystem.registerSystem()
        TEMPORARY_BOUNDING_BOX_PLACEMENT_SYSTEM.registerSystem()
    }
    
    // MARK: -  APP Body
    var body: some Scene {
        
        
        WindowGroup {
            HomeView()
                .environment(appState)
                .glassBackgroundEffect()
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)

        
        ImmersiveSpace(id: UIIdentifier.performanceSpace) {
            PerformanceRealityView()
                .environment(appState)
        }
        
        
        
    }
}

// MARK: - UTIL
enum UIIdentifier {
    static let performanceSpace = "Performance Space"
}

enum AttachmendIdentifier {
    case leftLoopRecordingView
    case rightLoopRecordingView
}
