//
//  SessionTrackView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 01.04.2025.
//

import SwiftUI

struct SessionTrackView: View {
    
    // RV Attachments hard cut the button border. We compensate this by adding a frame around each button
    let BUTTON_BORDER_COMPENSATION: CGFloat = 10
    
    @StateObject var track: LiveSessionTrack
    @State var stopRequested: Bool = false
    
    var body: some View {
        HStack {
            // MARK: - CLIP STOP BUTTON
            Button {
                guard self.track.state != .stopped else { return }
                self.stopRequested = true
                self.track.stopPlayback()
            } label: {
                Rectangle()
                    .opacity(0.7)
                    .clipShape(.rect(cornerRadius: 15))
                    .overlay(
                        Image(systemName: "stop")
                            .foregroundStyle(.black),
                        alignment: .center
                    )
            }
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.plain)
            .frame(width: SessionClipView.CLIP_BUTTON_WIDTH, height: SessionClipView.CLIP_BUTTON_HEIGHT)
            .foregroundStyle(self.stopRequested ? .red : .gray)
            .onChange(of: track.state) { _, newState in
                if newState == .stopped {
                    self.stopRequested = false
                }
            }
            
            // MARK: - CLIP LIST
            ForEach(track.clipSlotsAscending) { clipSlot in
                SessionClipView(clipSlot: clipSlot)
            }
        }
        // +1 comprensates the presence of the stop button
            .frame(width: (SessionClipView.CLIP_BUTTON_WIDTH + self.BUTTON_BORDER_COMPENSATION) * (CGFloat(GlobalConfig.LOOP_GRID_HEIGHT) + 1), height: SessionClipView.CLIP_BUTTON_HEIGHT + self.BUTTON_BORDER_COMPENSATION)
    }
}

#Preview {
    SessionTrackView(track: LiveSessionManager.shared.tracksAscending.first!)
}
