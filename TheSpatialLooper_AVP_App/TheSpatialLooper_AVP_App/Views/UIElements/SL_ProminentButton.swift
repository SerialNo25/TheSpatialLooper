//
//  SL_Button.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 07.04.2025.
//

import SwiftUI

struct SL_ProminentButton: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 20)
            .padding(.horizontal, 25)
            .background(
                color
                    .opacity(configuration.isPressed ? 1 : 0.8)
            )
            .clipShape(.rect(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    Button("Test") {
        
    }
    .buttonStyle(SL_ProminentButton(color: .green))
}
