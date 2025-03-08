//
//  TheSpatialLooper_AVP_AppApp.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 04.03.2025.
//

import SwiftUI

@main
struct TheSpatialLooper_AVP_AppApp: App {
    
    private var appState = AppState()
    
    // MARK: - Entity Component System initialization
    init() {
        // MARK: COMPONENTS
        LoopTriggerEntityComponent.registerComponent()
        FaceHeadsetComponent.registerComponent()
        
        // MARK: SYSTEMS
        FaceHeadsetSystem.registerSystem()
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
