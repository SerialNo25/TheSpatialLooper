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
    
    @State private var immersiveViewState: Bool = false
    @State private var looperActive: Bool = false
    
    var body: some View {
        VStack {
            
            // TODO: Placeholder while loading ReferenceObjects
            
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
            
            Toggle("ActivateLooper", isOn: $looperActive)
                .frame(width: 200)
                .onChange(of: looperActive) { _, newValue in
                    appState.looperActive = newValue
                }
            
        }
        .frame(width: 370)
        .padding(.all, 40)
        .onAppear() {
            self.looperActive = appState.looperActive
        }
    }
}

#Preview {
    HomeView()
        .glassBackgroundEffect()
        .environment(AppState.shared)
}
