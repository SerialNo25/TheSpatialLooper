//
//  SessionClipView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 24.03.2025.
//

import Foundation
import SwiftUI

struct SessionClipView: View {
    
    @StateObject var clipSlot: LiveSessionClipSlot
    
    var body: some View {
        Button {
            self.clipSlot.triggerClip()
        } label: {
            Rectangle()
                .opacity(self.clipSlot.state == .playing ? 0.8 : 0.5)
                .overlay(
                    ClipStateIndicator(clipSlot: self.clipSlot)
                        .clipShape(.rect(cornerRadius: 4))
                        .frame(width: 20, height: 20, alignment: .topTrailing)
                        .padding(12),
                    alignment: .topTrailing
                )
                .clipShape(.rect(cornerRadius: 15))
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.plain)
        .frame(width: 100, height: 70)
        .foregroundStyle(self.clipSlot.color)
        .opacity(self.clipSlot.state == .empty ? 0 : 1)
    }
    
}

struct ClipStateIndicator: View {
    
    @StateObject var clipSlot: LiveSessionClipSlot
    
    var body: some View {
        switch clipSlot.state {
        case .empty:
            Rectangle()
                .foregroundStyle(Color.gray)
                .opacity(0.3)
        case .recording:
            AnimatedIndicator(animationPeriod: 0.8)
                .foregroundStyle(Color.red)
        case .playing:
            Rectangle()
                .foregroundStyle(Color.green)
        case .recordingQueued:
            AnimatedIndicator(animationPeriod: 0.3)
                .foregroundStyle(Color.pink)
        case .stopped:
            Rectangle()
                .foregroundStyle(Color.gray)
        case .queued:
            AnimatedIndicator(animationPeriod: 0.2)
                .foregroundStyle(Color.green)
        }
    }
}

struct AnimatedIndicator: View {
    
    let animationPeriod: Double
    
    @State var animationTrigger = false
    
    var body: some View {
        Circle()
            .opacity(animationTrigger ? 0.9 : 0.3)
            .onAppear {
                toggle()
            }
    }
    
    func toggle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationPeriod) {
            withAnimation(.easeInOut(duration: animationPeriod)){
                animationTrigger.toggle()
            }
            toggle()
        }
    }
    
}

#Preview {
    let clipSlot = LiveSessionClipSlot(cellID: 1)
    clipSlot.midiIn_wasClipAdded()
    clipSlot.midiIn_wasColorChanged(0, 200, 200)
    clipSlot.midiIn_wasPlaybackStarted()
    return SessionClipView(clipSlot: clipSlot)
}
