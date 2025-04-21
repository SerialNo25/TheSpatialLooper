//
//  ContentView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 04.03.2025.
//

import SwiftUI
import RealityKit

struct HomeView: View {
    
    @StateObject private var midiSessionManager = MIDI_SessionManager.shared
    @StateObject private var referenceObjeceLoader = ReferenceObjectLoader.shared
    @State private var midiConnected = true
    
    var body: some View {
        VStack {
            NavigationStack {
                
                // MARK: - LOGO
                Image(.logoTransparent)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 102)
                
                Text("Spatial Looper")
                    .font(.title)
                
                // MARK: - REFERNECE OBJECT LOADING PLACEHOLDER
                if !referenceObjeceLoader.hasLoaded {
                    ReferenceObjectLoadingPlaceholderView()
                        .padding(.top)
                } else {
                    if !midiConnected {
                        // MARK: - MIDI NOT CONNECTED PAGE
                        MIDI_QuickConnectUtilityView()
                            .padding(.top)
                    } else {
                        // MARK: - MAIN PAGE
                        LooperControlView()
                        HomeViewSettingsView()
                            .padding(.top)
                    }
                }
            }
            // MARK: - STYLING
            .frame(width: 370, height: 580)
            .padding(.all, 40)
            .background(.accent.opacity(0.5))
            .glassBackgroundEffect()
            
            // MARK: - DATA MANAGEMENT
            .onAppear {
                midiConnected = midiSessionManager.isConnected
            }
            .onChange(of: midiSessionManager.isConnected) { _, newValue in
                switch newValue {
                case false:
                    midiConnected = false
                case true:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        midiConnected = true
                    }
                }
            }
        }
    }
}



// MARK: - SETTINGS
struct HomeViewSettingsView: View {
    var body: some View {
        Form {
            LoopTriggerModeSelectionView()
            NavigationLink("MIDI Setup 🎹") {
                MIDI_Settings()
            }
        }
        
        .padding(.horizontal, 25)
    }
}



// MARK: - LOOPER CONTROL
struct LooperControlView: View {
    @Environment(AppState.self) private var appState
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    
    @State private var immersiveViewState: Bool = false
    @State private var looperActive: Bool = false
    
    var body: some View {
        HStack {
            Toggle(immersiveViewState ? "Close" : "Open", isOn: $immersiveViewState)
                .onChange(of: immersiveViewState) { _, newValue in
                    Task {
                        switch newValue {
                        case true:
                            await openImmersiveSpace(id: UIIdentifier.performanceSpace)
                            if !appState.scenesOpen {
                                openWindow(id: WindowIdentifier.sceneView.rawValue)
                                if GlobalConfig.LOGGING_ACTIVE {
                                    openWindow(id: WindowIdentifier.loggingView.rawValue)
                                }
                            }
                        case false: await dismissImmersiveSpace()
                        }
                    }
                }
                .toggleStyle(.button)
                .buttonStyle(SL_ProminentButton(color: immersiveViewState ? .green : .buttonOff))
                .frame(width: 100)
            
            
            Toggle(looperActive ? "Disarm Looper" : "   Arm Looper   ", isOn: $looperActive)
                .onChange(of: looperActive) { _, newValue in
                    appState.looperActive = newValue
                }
                .onAppear() {
                    self.looperActive = appState.looperActive
                }
                .toggleStyle(.button)
                .buttonStyle(SL_ProminentButton(color: looperActive ? .red : .red.opacity(0.5)))
                .frame(width: 170)
        }
    }
}



// MARK: - LOOP TRIGGER MODE SELECTION MENU
struct LoopTriggerModeSelectionView: View {
    @Environment(AppState.self) private var appState
    
    @State private var loopTriggerMode: LoopTriggerMode = .discardOnLeave
    
    var body: some View {
        Picker("Trigger Mode", selection: $loopTriggerMode) {
            ForEach(LoopTriggerMode.allCases) { triggerMode in
                Text(triggerMode.rawValue).tag(triggerMode)
            }
        }
        .pickerStyle(.inline)
        .onChange(of: loopTriggerMode) { _, newValue in
            appState.loopTriggerMode = newValue
        }
        .onAppear {
            self.loopTriggerMode = appState.loopTriggerMode
        }
    }
    
}



// MARK: - MIDI QUICK CONNECT BUTTON
struct MIDI_QuickConnectUtilityView: View {
    
    @StateObject private var midiSessionManager = MIDI_SessionManager.shared
    @State private var wasPressed = false
    
    var body: some View {
        if midiSessionManager.isConnected {
            Text("Connected")
                .font(.title)
            Image(systemName: "checkmark")
                .foregroundStyle(.green)
                .font(.title)
        } else {
            VStack {
                
                Text(wasPressed ? "Connecting ..." : "MIDI Not Connected")
                
                
                Button("Quick Connect MIDI Session") {
                    wasPressed = true
                    if !midiSessionManager.sessionActive { midiSessionManager.enableSession() }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        midiSessionManager.connectSession()
                    }
                }
                .buttonStyle(SL_ProminentButton(color: wasPressed ? .yellow : .buttonOff))
            }
        }
        
    }
}


// MARK: - REFERENCE OBJECT LOADING PLACEHOLDER
struct ReferenceObjectLoadingPlaceholderView: View {
    
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading Reference Objects")
                .font(.title)
        }
    }
    
}



#Preview {
    HomeView()
        .environment(AppState.shared)
}
