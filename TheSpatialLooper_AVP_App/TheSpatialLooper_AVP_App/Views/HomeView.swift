//
//  ContentView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 04.03.2025.
//

import SwiftUI
import RealityKit

struct HomeView: View {
    
    @State private var immersiveViewState: Bool = false
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    var body: some View {
        VStack {
            
            Text("Welcome to Spatial Looper")
                .font(.title)
            
            Toggle("Enable", isOn: $immersiveViewState)
                .frame(width: 200)
                .onChange(of: immersiveViewState) { _, new in
                    Task {
                        switch new {
                        case true: await openImmersiveSpace(id: UIIdentifier.performanceSpace)
                        case false: await dismissImmersiveSpace()
                        }
                    }
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
