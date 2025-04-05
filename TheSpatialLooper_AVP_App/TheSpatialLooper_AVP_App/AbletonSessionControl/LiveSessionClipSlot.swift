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
    var parentTrack: LiveSessionTrack
    
    var deleteNextClip = false
    
    @Published private var _color = Color.black
    public var color: Color {
        if !hasClip {
            return .clear
        }
        return self._color
    }
    
    @Published private var hasClip = false
    @Published private var playbackState = ClipPlaybackState.stopped
    
    init(cellID: Int, track: LiveSessionTrack) {
        self.midiNoteID = cellID
        self.parentTrack = track
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
    
    func cancelRecording() {
        // clips can only be deleted when present. If the clip is queued but recording has not yet started, we schedule the clip to be deleted when present
        if self.hasClip {
            self.deleteClip()
        } else {
            self.deleteNextClip = true
        }
    }
    
    func stopPlayback() {
        MIDI_SessionManager.shared.sendMIDIMessage(MIDI_UMP_Packet.constructStopClipMessage(clipSlotNumber: midiNoteID))
    }
    
    // MARK: - Interactions from MIDI Interface
    
    func midiIn_wasColorChanged(_ r: Int, _ g: Int, _ b: Int) {
        self._color = Color(red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255)
        
        self.parentTrack.updateState()
    }
    
    func midiIn_wasClipAdded() {
        hasClip = true
        
        if deleteNextClip {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.deleteClip()
            }
            self.deleteNextClip = false
        }
        
        self.parentTrack.updateState()
    }
    
    func midiIn_wasClipRemoved() {
        hasClip = false
        
        self.parentTrack.updateState()
    }
    
    func midiIn_wasStopped() {
        self.playbackState = .stopped
        
        self.parentTrack.updateState()
    }
    
    func midiIn_wasQueued() {
        self.playbackState = .queued
        
        self.parentTrack.updateState()
    }
    
    func midiIn_wasPlaybackStarted() {
        self.playbackState = .playing
        
        self.parentTrack.updateState()
    }
    
    func midiIn_wasRecordingStarted() {
        self.playbackState = .recording
        
        self.parentTrack.updateState()
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
