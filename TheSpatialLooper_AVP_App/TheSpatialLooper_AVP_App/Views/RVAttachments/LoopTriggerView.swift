//
//  LoopRecordingView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import SwiftUI

struct LoopTriggerView: View {
    
    @StateObject var loopTriggerEntity: LoopTriggerEntity
    let buttonOpacity: CGFloat = 0.4
    
    var name: String
    var body: some View {
        VStack {
            if loopTriggerEntity.isArmed {
                
                // MARK: - LOOPING ACTIVE
                if loopTriggerEntity.activeLoopSource != nil {
                    VStack {
                        if AppState.shared.loopTriggerMode == .commitOnLeave {
                            Button {
                                loopTriggerEntity.discardLoop()
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .font(.title)
                            }
                            .foregroundStyle(.red)
                            .buttonStyle(.plain)
                        }
                        
                        Button {
                            loopTriggerEntity.reStartLoop()
                        } label: {
                            Image(systemName: "restart.circle.fill")
                                .font(.title)
                        }
                        .foregroundStyle(.yellow)
                        .buttonStyle(.plain)
                        
                        Button {
                            loopTriggerEntity.commitLoop()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                        }
                        .foregroundStyle(.green)
                        .buttonStyle(.plain)
                    }
                    .frame(width: 50, height: 125)
                    
                }
                // MARK: - LOOPING INACTIVE
                else {
                    Image(systemName: "circle.circle.fill")
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.green.opacity(0.8))
                }
                
            } else {
                // MARK: - DISABLED
                Image(systemName: "circle.slash.fill")
                    .font(.title)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.red.opacity(0.8))
            }
        }
        
        // TODO: Remove
//        LoopTriggerArmToggleView(loopTriggerEntity: loopTriggerEntity)
//            .frame(width: 200)
        
    }
}

// TODO: Remove this
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
}
