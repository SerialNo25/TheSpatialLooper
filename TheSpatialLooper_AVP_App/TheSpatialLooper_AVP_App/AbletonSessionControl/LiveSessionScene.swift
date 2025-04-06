//
//  LiveSessionScene.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.04.2025.
//

import Foundation

class LiveSessionScene: Identifiable {
    private var configuredClipsByTrackID: [Int: LiveSessionClipSlot?] = [:]
    init() {
        for trackID in 0..<GlobalConfig.LOOP_GRID_WIDTH {
            configuredClipsByTrackID[trackID] = LiveSessionManager.shared.tracks[trackID]?.findPlayingClip()
        }
    }
    
    func trigger() {
        for (trackID, clipSlot) in configuredClipsByTrackID {
            if clipSlot != nil {
                clipSlot?.triggerClip()
            } else {
                guard trackID < LiveSessionManager.shared.tracksAscending.count else { continue }
                LiveSessionManager.shared.tracksAscending[trackID].stopPlayback()
            }
        }
    }
}
