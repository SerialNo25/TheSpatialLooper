//
//  SceneView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.04.2025.
//

import SwiftUI

struct SceneListView: View {
    
    @Environment(AppState.self) private var appState
    
    @StateObject private var sessionManager = LiveSessionManager.shared
    
    var body: some View {
        VStack {
            
            // MARK: - ADD BUTTON
            Button {
                LiveSessionManager.shared.createScenFromCurrentPlayback()
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .padding(.horizontal, 20)
            }
            .buttonStyle(SL_ProminentButton(color: .green))
            .padding(.top, 20)
            
            // MARK: - SCENE LIST
            List {
                ForEach(sessionManager.scenes) { scene in
                    SceneView(scene: scene)
                }.onDelete { indexSet in
                    sessionManager.deleteScene(at: indexSet)
                }
            }
            .padding(.horizontal)
        }
        
        // MARK: - STYLING
        .padding(.vertical)
        .frame(width: 200, height: 500)
        .background(.accent.opacity(0.5))
        .glassBackgroundEffect()
        
        // MARK: - DATA MANAGEMENT
        .onAppear {
            appState.scenesOpen = true
        }
        .onDisappear {
            appState.scenesOpen = false
        }
    }
}



struct SceneView: View {
    
    let scene: LiveSessionScene
    
    var body: some View {
        Button {
            scene.trigger()
        } label: {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title)
                Spacer()
                Text(String(scene.playingClipCount))
            }
        }
        .foregroundStyle(scene.sceneColor)
    }
}

#Preview {
    SceneListView()
        .environment(AppState.shared)
}
