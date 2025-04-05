//
//  SessionManager.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 23.03.2025.
//

import Foundation

class LiveSessionManager {
    // MARK: - SINGLETON
    static var shared = LiveSessionManager()
    private init(){
        for trackID in 0..<GlobalConfig.LOOP_GRID_WIDTH {
            tracks[trackID] = LiveSessionTrack(sessionHeight: GlobalConfig.LOOP_GRID_HEIGHT, trackID: trackID)
        }
    }
    
    private(set) var tracks: [Int : LiveSessionTrack] = [:]
    var tracksAscending: [LiveSessionTrack] {
        tracks.values.sorted(by: {a,b in a.trackID < b.trackID})
    }
    
    
    func findClipSlot(midiNoteID: Int) -> LiveSessionClipSlot? {
        for track in tracksAscending {
            if let trackFound = track.clipSlots[midiNoteID] { return trackFound }
        }
        return nil
    }
    
    
}
