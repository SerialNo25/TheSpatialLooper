//
//  LoopRecordingView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import SwiftUI

struct LoopRecordingView: View {
    
    @StateObject var loopTriggerEntity: LoopTriggerEntity
    
    var name: String
    var body: some View {
        VStack {
            Text("Imagine this was implemented 🙃")
            Text("This is: \(name)")
            Button("COMMIT") {
                loopTriggerEntity.commitLoop()
            }
            .opacity(loopTriggerEntity.activeLoopSource != nil ? 1 : 0)
        }
        .padding()
        
        
    }
}

#Preview {
    LoopRecordingView(loopTriggerEntity: LoopTriggerEntity(), name: "a test")
}
