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
    
    init() {
        // MARK: - APP INIT
        Task {
            await ReferenceObjectLoader.shared.load()
        }
        
        // MARK: - Entity Component System initialization
        // MARK: COMPONENTS
        LoopTriggerEntityComponent.registerComponent()
        LoopSourceEntityComponent.registerComponent()
        FaceHeadsetComponent.registerComponent()
        FlickGestureComponent.registerComponent()
        
        // MARK: SYSTEMS
        FaceHeadsetSystem.registerSystem()
        WristFlickGestureSystem.registerSystem()
    }
    
    // MARK: -  APP Body
    var body: some Scene {
        
        
        WindowGroup {
            HStack{
                HomeView()
                    .environment(appState)
            }
            .frame(width: 2000)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        
        WindowGroup(id: WindowIdentifier.sceneView.rawValue) {
            SceneListView()
                .environment(appState)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        
        ImmersiveSpace(id: UIIdentifier.performanceSpace) {
            PerformanceRealityView()
                .environment(appState)
        }
        
        
        
    }
}

enum WindowIdentifier: String {
    case sceneView = "SceneView"
}
