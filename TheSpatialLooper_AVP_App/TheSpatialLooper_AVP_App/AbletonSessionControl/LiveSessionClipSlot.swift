//
//  LiveSessionClipSlot.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 24.03.2025.
//

import Foundation
import SwiftUI

class LiveSessionClipSlot: ObservableObject, Identifiable {
    
    var midiNoteID: Int
    
    @Published private var _color = Color.black
    public var color: Color {
        if !hasClip {
            return .clear
        }
        return self._color
    }
    
    @Published private var hasClip = false
    @Published private var playbackState = ClipPlaybackState.stopped
    
    init(cellID: Int) {
        self.midiNoteID = cellID
    }
    
    var state: ClipSlotState {
        switch playbackState {
        case .stopped:
            return hasClip ? .stopped : .empty
        case .queued:
            return hasClip ? .queued : .recordingQueued
        case .playing:
            return .playing
        case .recording:
            return .recording
        }
    }
    
    // MARK: - Interactions from App
    func triggerClip() {
        MIDI_SessionManager.shared.sendMIDIMessage(MIDI_UMP_Packet.constructLoopTriggerMessage(clipSlotNumber: midiNoteID))
    }
    
    func deleteClip() {
        MIDI_SessionManager.shared.sendMIDIMessage(MIDI_UMP_Packet.constructDeleteClipMessage(clipSlotNumber: midiNoteID))
    }
    
    // MARK: - Interactions from MIDI Interface
    
    func midiIn_wasColorChanged(_ r: Int, _ g: Int, _ b: Int) {
        self._color = Color(red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255)
    }
    
    func midiIn_wasClipAdded() {
        hasClip = true
    }
    
    func midiIn_wasClipRemoved() {
        hasClip = false
    }
    
    func midiIn_wasStopped() {
        self.playbackState = .stopped
    }
    
    func midiIn_wasQueued() {
        self.playbackState = .queued
    }
    
    func midiIn_wasPlaybackStarted() {
        self.playbackState = .playing
    }
    
    func midiIn_wasRecordingStarted() {
        self.playbackState = .recording
    }
}

enum ClipPlaybackState {
    case stopped
    case queued
    case playing
    case recording
}

enum ClipSlotState {
    case empty
    case recordingQueued
    case recording
    case playing
    case stopped
    case queued
}
