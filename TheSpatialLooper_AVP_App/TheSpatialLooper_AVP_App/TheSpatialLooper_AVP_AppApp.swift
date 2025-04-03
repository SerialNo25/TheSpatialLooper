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
        
        // MARK: SYSTEMS
        FaceHeadsetSystem.registerSystem()
        LoopTriggerSystem.registerSystem()
    }
    
    // MARK: -  APP Body
    var body: some Scene {
        
        
        WindowGroup {
            HStack{
                VStack{
                    HomeView()
                        .environment(appState)
                        .glassBackgroundEffect()
                    MIDI_Settings()
                        .glassBackgroundEffect()
                }
                if appState.looperActive {
                    // TODO: Remove
                    VStack {
                        SessionTrackView(track: LiveSessionManager.shared.tracksAscending[0])
                        SessionTrackView(track: LiveSessionManager.shared.tracksAscending[1])
                        SessionTrackView(track: LiveSessionManager.shared.tracksAscending[2])
                        SessionTrackView(track: LiveSessionManager.shared.tracksAscending[3])
                        SessionTrackView(track: LiveSessionManager.shared.tracksAscending[4])
                    }
                }
            }
            .frame(width: 2000)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)

        
        ImmersiveSpace(id: UIIdentifier.performanceSpace) {
            PerformanceRealityView()
                .environment(appState)
        }
        
        
        
    }
}
