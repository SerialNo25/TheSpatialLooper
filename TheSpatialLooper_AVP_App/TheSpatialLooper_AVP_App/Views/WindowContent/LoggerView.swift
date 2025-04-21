//
//  LoggerView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 21.04.2025.
//

import SwiftUI

struct LoggerView: View {
    @Environment(AppState.self) private var appState
    
    @State var generateLog: Bool = false
    
    var body: some View {
        VStack {
            Toggle("Generate Log", isOn: $generateLog)
            if generateLog {
                ShareLink(item: appState.leftHandLogger.exportLog()) {
                    Text("Export left hand log")
                }
                ShareLink(item: appState.rightHandLogger.exportLog()) {
                    Text("Export right hand log")
                }
            }
        }
        .padding()
        .frame(width: 250)
        .glassBackgroundEffect()
    }
}

#Preview {
    LoggerView()
        .environment(AppState.shared)
}
