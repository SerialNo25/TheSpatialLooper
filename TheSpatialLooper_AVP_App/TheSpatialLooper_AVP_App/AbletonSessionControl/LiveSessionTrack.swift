//
//  LiveSessionTrack.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 24.03.2025.
//

import Foundation

class LiveSessionTrack: Identifiable {
    
    // TODO: Map a loop source here
    
    var trackID: Int
    
    
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
    
    private(set) var clipSlots: [Int : LiveSessionClipSlot] = [:]
    var clipSlotsAscending: [LiveSessionClipSlot] {
        clipSlots.values.sorted(by: {a,b in a.midiNoteID < b.midiNoteID})
    }
    
}
