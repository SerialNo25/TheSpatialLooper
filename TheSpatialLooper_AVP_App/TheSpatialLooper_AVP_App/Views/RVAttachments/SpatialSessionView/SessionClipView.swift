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
            HStack {
                ClipStateIndicator(clipSlot: self.clipSlot)
                    .frame(width: 20, height: 20)
                    .padding(0.1)
                Text(String(self.clipSlot.midiNoteID))
            }
        }
        .tint(self.clipSlot.color)
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
            AnimatedIndicator(animationPeriod: 0.3)
                .foregroundStyle(Color.green)
        }
    }
}

struct AnimatedIndicator: View {
    
    let animationPeriod: Double
    
    @State var animationTrigger = false
    
    var body: some View {
        Circle()
            .opacity(animationTrigger ? 1 : 0.1)
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
