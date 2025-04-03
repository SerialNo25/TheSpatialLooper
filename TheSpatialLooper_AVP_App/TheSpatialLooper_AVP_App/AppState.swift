//
//  AppState.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

import Foundation

@Observable
class AppState {
    
    // MARK: - SINGLETON
    public static let shared = AppState()
    private init(){}
    
    // MARK: - LOOPER CONTROL
    var looperActive: Bool = false {
        didSet {
            MIDI_SessionManager.shared.sendMIDIMessage(MIDI_UMP_Packet.constructStatusUpdateRequestMessage())
        }
    }
    
}
