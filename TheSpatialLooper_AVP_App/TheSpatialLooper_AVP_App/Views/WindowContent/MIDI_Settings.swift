//
//  MIDI_Settings.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 09.03.2025.
//

import SwiftUI
import CoreMIDI

struct MIDI_Settings: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - TITLE
                Text("MIDI Setup 🎹")
                    .font(.title)
                    .padding()
                
                // MARK: - FORM
                Form {
                    Section("Network Session") {
                        
                        MIDI_SessionToggleView()
                        
                        MIDI_ConnectSessionButton()
                        
                        NavigationLink("Connection Details") {
                            ConnectionInfoView()
                        }
                    }
                    
                    
                    Section("MIDI Channel") {
                        MIDI_ChannelSelectionView()
                    }
                }
                
            }
        }
        .frame(width: 370, height: 420)
        .padding(.all, 40)
    }
}

// MARK: - MIDI SESSION TOGGLE
struct MIDI_SessionToggleView: View {
    
    @StateObject private var midiSessionManager = MIDI_SessionManager.shared
    @State private var midiSessionActive = false
    
    var body: some View {
        Toggle("MIDI Session", isOn: $midiSessionActive)
            .onChange(of: midiSessionActive) { _, newValue in
                switch newValue {
                case true:
                    midiSessionManager.enableSession()
                case false:
                    midiSessionManager.disableSession()
                }
            }
            .onAppear {
                midiSessionActive = midiSessionManager.sessionActive
            }
    }
}


// MARK: - MIDI CONNECT BUTTON
struct MIDI_ConnectSessionButton: View {
    
    @StateObject private var midiSessionManager = MIDI_SessionManager.shared
    
    var body: some View {
        HStack {
            Button("Connect Session") {
                midiSessionManager.connectSession()
            }
            Spacer()
            Text(midiSessionManager.isConnected ? "Fully Connected" : "")
        }
    }
}

// MARK: - MIDI CHANNEL SELECTION
struct MIDI_ChannelSelectionView: View {
    
    @StateObject private var midiSessionManager = MIDI_SessionManager.shared
    @State private var midiChannel = 1
    
    var body: some View {
        Stepper(
            value: $midiChannel,
            in: 1...16,
            step: 1
        ) {
            Text("Current: \(midiChannel)")
        }
        .onChange(of: midiChannel) { _, newValue in
            midiSessionManager.setMidiChannel(newValue-1)
        }
        .onAppear {
            midiChannel = midiSessionManager.midiChannel + 1
        }
    }
}


// MARK: - MIDI CONNECTION DETAILS
struct ConnectionInfoView: View {
    
    @StateObject private var midiSessionManager = MIDI_SessionManager.shared
    
    var body: some View {
        Form {
            Section("Connection Details") {
                
                MenuItemView(title: "Source:", value: unwrapOptionalIDToString(midiSessionManager.connectedSource))
                
                MenuItemView(title: "Destination:", value: unwrapOptionalIDToString(midiSessionManager.connectedDestination))
            }
        }
    }
    
    func unwrapOptionalIDToString(_ optionalID: MIDIEndpointRef?) -> String {
        if let id = optionalID {
            return String(id)
        } else {
            return "Not Connected"
        }
    }
    
}

struct MenuItemView: View {
    
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
}




#Preview {
    MIDI_Settings()
        .glassBackgroundEffect()
}
