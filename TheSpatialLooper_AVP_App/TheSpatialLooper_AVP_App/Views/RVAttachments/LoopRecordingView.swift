//
//  LoopRecordingView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import SwiftUI

struct LoopRecordingView: View {
    var name: String
    var body: some View {
        VStack {
            Text("Imagine this was implemented 🙃")
            Text("This is: \(name)")
        }
        .padding()
    }
}

#Preview {
    LoopRecordingView(name: "a test")
        .glassBackgroundEffect()
}
