//
//  SceneView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.04.2025.
//

import SwiftUI

struct SceneView: View {
    
    @Environment(AppState.self) private var appState
    
    @StateObject private var sessionManager = LiveSessionManager.shared
    
    var body: some View {
        VStack {
            Button("+") {
                LiveSessionManager.shared.createScenFromCurrentPlayback()
            }
            
            List {
                ForEach(sessionManager.scenes) { scene in
                    Button("scene") {
                        scene.trigger()
                    }
                }.onDelete { indexSet in
                    sessionManager.deleteScene(at: indexSet)
                }
            }
        }
        .onAppear {
            appState.scenesOpen = true
        }
        .onDisappear {
            appState.scenesOpen = false
        }
    }
}

#Preview {
    SceneView()
}
