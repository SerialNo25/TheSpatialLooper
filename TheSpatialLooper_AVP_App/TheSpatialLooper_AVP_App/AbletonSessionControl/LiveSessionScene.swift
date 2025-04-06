//
//  LiveSessionScene.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.04.2025.
//

import Foundation
import SwiftUI

class LiveSessionScene: Identifiable {
    
    static var colorID: Int = 0
    static let sceneColors: [Color] = [
        .red,
        .green,
        .blue,
        .yellow,
        .cyan,
        .indigo,
        .teal,
        .purple
    ]
    
    private var configuredClipsByTrackID: [Int: LiveSessionClipSlot?] = [:]
    let sceneColor: Color
    init() {
        for trackID in 0..<GlobalConfig.LOOP_GRID_WIDTH {
            configuredClipsByTrackID[trackID] = LiveSessionManager.shared.tracks[trackID]?.findPlayingClip()
        }
        self.sceneColor = Self.sceneColors[Self.colorID]
        Self.colorID = (Self.colorID + 1) % Self.sceneColors.count
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
