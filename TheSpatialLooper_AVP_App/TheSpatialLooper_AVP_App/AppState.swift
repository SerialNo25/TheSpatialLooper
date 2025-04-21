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
    
    var loopTriggerMode: LoopTriggerMode = .commitOnLeave
    
    var scenesOpen: Bool = false
    
    // MARK: - DEV TOOLS
    let leftHandLogger = HandPositionLogger(loggerName: "LeftHand")
    let rightHandLogger = HandPositionLogger(loggerName: "RightHand")
    
}

enum LoopTriggerMode: String, CaseIterable, Identifiable {
    var id: Self { self }
    case commitOnLeave = "Commit on Leave"
    case discardOnLeave  = "Discard on Leave"
}
