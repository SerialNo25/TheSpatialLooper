//
//  ContentView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 04.03.2025.
//

import SwiftUI
import RealityKit

struct HomeView: View {
    
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    @Environment(AppState.self) private var appState
    
    // TODO: These properties need to be loaded on view appear
    @State private var immersiveViewState: Bool = false
    @State private var manualPlacementMode: Bool = false
    
    var body: some View {
        VStack {
            
            Text("Welcome to Spatial Looper")
                .font(.title)
            
            Toggle("Enable", isOn: $immersiveViewState)
                .frame(width: 200)
                .onChange(of: immersiveViewState) { _, newValue in
                    Task {
                        switch newValue {
                        case true: await openImmersiveSpace(id: UIIdentifier.performanceSpace)
                        case false: await dismissImmersiveSpace()
                        }
                    }
                }
            
            // TODO: Remove
            Toggle("ManualPlacement", isOn: $manualPlacementMode)
                .frame(width: 200)
                .onChange(of: manualPlacementMode) { _, newValue in
                    appState.isPlacingBoundingBox = newValue
                }
        }
        .frame(width: 370)
        .padding(.all, 40)
    }
}

#Preview {
    HomeView()
        .glassBackgroundEffect()
}
