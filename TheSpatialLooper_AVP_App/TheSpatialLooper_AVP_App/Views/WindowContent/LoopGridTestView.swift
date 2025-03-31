//
//  LoopGridTestView.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 13.03.2025.
//

import SwiftUI

// TODO: Remove Temporary Class
struct LoopGridTestView: View {
    
    var sessionManager = LiveSessionManager.shared
    
    var body: some View {
        Grid() {
            //            ForEach(sessionManager.tracksAscending) { track in
            //
            //                GridRow() {
            //
            //                    ForEach(track.clipSlotsAscending) { clipSlot in
            //                        SessionClipView(clipSlot: clipSlot)
            //                    }
            //
            //                }
            //
            //            }
            
            ForEach(sessionManager.tracksAscending.first!.clipSlotsAscending) { clipSlot in
                GridRow() {
                    SessionClipView(clipSlot: clipSlot)
                }
            }
            
            
            
        }
        .onAppear {
            // Fetch update from ableton on appear
            MIDI_SessionManager.shared.sendMIDIMessage(MIDI_UMP_Packet.constructStatusUpdateRequestMessage())
        }
        .padding()
        
        // TODO: REMOVE TEMP STUFF
        /*
         VStack{
         Button("ChangeColor"){
         
         sessionManager.findClipSlot(midiNoteID: 0)?.midiIn_wasColorChanged(10, 255, 0)
         
         
         sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasQueued()
         sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasClipAdded()
         sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasRecordingStarted()
         sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasPlaybackStarted()
         sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasStopped()
         sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasQueued()
         sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasStopped()
         //                sessionManager.tracksAscending[0].clipSlotsAscending[0].midiIn_wasClipRemoved()
         }
         }
         */
    }
    
}




#Preview {
    LoopGridTestView()
        .glassBackgroundEffect()
}
