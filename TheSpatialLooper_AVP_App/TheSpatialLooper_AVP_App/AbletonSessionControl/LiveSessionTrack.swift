//
//  LiveSessionTrack.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 24.03.2025.
//

import Foundation

class LiveSessionTrack: ObservableObject, Identifiable {
    
    let trackID: Int
    let trackFirstCellOffset: Int
    
    @Published var state: TrackState = .stopped
    
    private var nextRecordingSlotID = 1
    
    init(sessionHeight: Int, trackID: Int) {
        let firstCellIndex = trackID * sessionHeight
        
        // start indexing at one to be consistent with cell IDs
        self.trackID = trackID + 1

        self.trackFirstCellOffset = firstCellIndex
        
        for cellIndex in firstCellIndex..<(firstCellIndex + sessionHeight) {
            // start indexing at one to keep midi note 0 free for internal use
            let cellID = cellIndex + 1
            clipSlots[cellID] = (LiveSessionClipSlot(cellID: cellID, track: self))
        }
    }
    
    // MARK: - TRACK STATE
    func updateState() {
        if findPlayingClip() != nil {
            self.state = .playing
            return
        }
        
        if findRecordingClip() != nil {
            self.state = .recording
            return
        }
        
        self.state = .stopped
    }
    
    // MARK: - INTERNAL SLOT MANAGEMENT
    private(set) var clipSlots: [Int : LiveSessionClipSlot] = [:]
    var clipSlotsAscending: [LiveSessionClipSlot] {
        clipSlots.values.sorted(by: {a,b in a.midiNoteID < b.midiNoteID})
    }
    
    private func assignRecordingSlot() -> LiveSessionClipSlot? {
        for _ in 0..<clipSlots.count {
            guard let currentClip = self.clipSlots[nextRecordingSlotID + trackFirstCellOffset] else { fatalError("Tried to index nil clip slot. This must be an error in either initialization or indexing") }
            if currentClip.state == .empty {
                return currentClip
            }
            nextRecordingSlotID += 1
            if nextRecordingSlotID > clipSlots.count { nextRecordingSlotID = 1 }
        }
        return nil
    }
    
    func findRecordingClip() -> LiveSessionClipSlot? {
        for clip in clipSlots.values {
            if clip.state == .recording || clip.state == .recordingQueued {
                return clip
            }
        }
        return nil
    }
    
    func findPlayingClip() -> LiveSessionClipSlot? {
        for clip in clipSlots.values {
            if clip.state == .playing {
                return clip
            }
        }
        return nil
    }
    
    
    
    // MARK: - TRACK CONTROL
    func startRecording() {
        // INV: only record if no recording is ongoing
        guard findRecordingClip() == nil else { return }
        
        guard let recordingSlot = assignRecordingSlot() else { return }
        recordingSlot.triggerClip()
    }
    
    func stopRecording() {
        guard let recordingClip = findRecordingClip() else { return }
        recordingClip.triggerClip()
    }
    
    func cancelRecording() {
        guard let recordingClip = findRecordingClip() else { return }
        recordingClip.cancelRecording()
    }
    
    func stopPlayback() {
        guard let playingClip = findPlayingClip() else { return }
        playingClip.stopPlayback()
    }
    
    func reStartLoop() {
        guard let recordingClip = findRecordingClip() else { return }
        recordingClip.reStartRecording()
    }
    
}


enum TrackState {
    case stopped
    case playing
    case recording
}
