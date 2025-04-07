//
//  LoopRecordingView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import SwiftUI

struct LoopTriggerView: View {
    
    @StateObject var loopTriggerEntity: LoopTriggerEntity
    
    var name: String
    var body: some View {
        VStack {
            LoopTriggerArmToggleView(loopTriggerEntity: loopTriggerEntity)
            VStack {
                if AppState.shared.loopTriggerMode == .commitOnLeave {
                    Button("DISCARD") {
                        loopTriggerEntity.discardLoop()
                    }
                }
                
                Button("COMMIT") {
                    loopTriggerEntity.commitLoop()
                }
                
                Button("RE-START") {
                    loopTriggerEntity.reStartLoop()
                }
            }
            // TODO: Add this again
//                        .opacity(loopTriggerEntity.activeLoopSource != nil ? 1 : 0)
            //            .padding()
        }
        .frame(width: 160)
        
    }
}

struct LoopTriggerArmToggleView: View {
    
    @StateObject var loopTriggerEntity: LoopTriggerEntity
    
    @State var isArmed: Bool = false
    
    var body: some View {
        Toggle(isOn: $isArmed) {
            Text("Arm")
        }
        .onChange(of: isArmed) { _, newValue in
            loopTriggerEntity.isArmed = newValue
            
        }
        .onAppear {
            isArmed = loopTriggerEntity.isArmed
        }
        .onChange(of: loopTriggerEntity.isArmed) { _, newValue in
            isArmed = loopTriggerEntity.isArmed
        }
        .padding()
    }
}

#Preview {
    LoopTriggerView(loopTriggerEntity: LoopTriggerEntity(), name: "a test")
        .glassBackgroundEffect()
}
