//
//  LiveSessionTrack.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 24.03.2025.
//

import Foundation

class LiveSessionTrack: Identifiable {
    
    // TODO: Map a loop source here
    
    let trackID: Int
    
    private var nextRecordingSlotID = 1
    
    
    init(sessionHeight: Int, trackID: Int) {
        // start indexing at zero to be consistent with cell IDs
        self.trackID = trackID + 1
        let firstCellID = trackID * sessionHeight
        for cellID in firstCellID..<(firstCellID + sessionHeight) {
            // start indexing at zero to keep midi note 0 free
            let startOneCellID = cellID + 1
            clipSlots[startOneCellID] = (LiveSessionClipSlot(cellID: startOneCellID))
        }
    }
    
    // MARK: - INTERNAL SLOT MANAGEMENT
    private(set) var clipSlots: [Int : LiveSessionClipSlot] = [:]
    var clipSlotsAscending: [LiveSessionClipSlot] {
        clipSlots.values.sorted(by: {a,b in a.midiNoteID < b.midiNoteID})
    }
    
    private func assignRecordingSlot() -> LiveSessionClipSlot? {
        for _ in 0..<clipSlots.count {
            guard let currentClip = self.clipSlots[nextRecordingSlotID] else { fatalError("Tried to index nil clip slot. This must be an error in either initialization or indexing") }
            if currentClip.state == .empty {
                return currentClip
            }
            nextRecordingSlotID += 1
            if nextRecordingSlotID >= clipSlots.count { nextRecordingSlotID = 1 }
        }
        return nil
    }
    
    private func findRecordingClip() -> LiveSessionClipSlot? {
        for clip in clipSlots.values {
            if clip.state == .recording {
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
        recordingClip.deleteClip()
    }
    
}
