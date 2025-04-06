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
        .opacity(loopTriggerEntity.activeLoopSource != nil ? 1 : 0)
        .padding()
        
    }
}

#Preview {
    LoopTriggerView(loopTriggerEntity: LoopTriggerEntity(), name: "a test")
}
