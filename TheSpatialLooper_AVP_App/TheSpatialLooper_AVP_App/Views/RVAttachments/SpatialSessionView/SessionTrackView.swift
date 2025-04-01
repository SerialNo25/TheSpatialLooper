//
//  SessionTrackView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 01.04.2025.
//

import SwiftUI

struct SessionTrackView: View {
    
    var track: LiveSessionTrack
    
    var body: some View {
        HStack {
            ForEach(track.clipSlotsAscending) { clipSlot in
                SessionClipView(clipSlot: clipSlot)
            }
            VStack {
                Button("Record") {
                    track.startRecording()
                }
                Button("Stop Record") {
                    track.stopRecording()
                }
                Button("Cancel Record") {
                    track.cancelRecording()
                }
            }
            .padding()
            .glassBackgroundEffect()
        }
    }
}

#Preview {
    SessionTrackView(track: LiveSessionManager.shared.tracksAscending.first!)
}
