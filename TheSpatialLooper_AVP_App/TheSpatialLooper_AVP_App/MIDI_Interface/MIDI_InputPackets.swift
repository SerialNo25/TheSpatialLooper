//
//  MIDI_InputPackets.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 24.03.2025.
//

import Foundation

// MARK: - PACKET PROTOCOL DEFINITION
protocol SL_MidiInputPacket {
    func getPacketLength() -> Int
    func triggerPacketAction()
}


// MARK: - CLIP STATE
struct SL_ClipStatePacket: SL_MidiInputPacket {
    
    /// We just consider the first "getPacketLength" integers
    var packetContent: ArraySlice<UInt8>
    
    func getPacketLength() -> Int {
        return 3
    }
    
    func triggerPacketAction() {
        
        let startIndex = packetContent.startIndex
        
        guard self.packetContent.indices.contains(startIndex) else { return }
        guard self.packetContent[startIndex] == 144 else { return }
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 1)) else { return }
        let note = self.packetContent[startIndex.advanced(by: 1)]
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 2)) else { return }
        let function = self.packetContent[startIndex.advanced(by: 2)]
        
        updateClipState(note, function)
    }
    
    private func updateClipState(_ clipID: UInt8, _ clipStateMidiID: UInt8) {
        guard let clipSlot = LiveSessionManager.shared.findClipSlot(midiNoteID: Int(clipID)) else { return }
        
        DispatchQueue.main.async {
            if clipStateMidiID == 0 {
                clipSlot.midiIn_wasStopped()
            }
            
            if clipStateMidiID == 127 {
                clipSlot.midiIn_wasPlaybackStarted()
            }
            
            if clipStateMidiID == 121 || clipStateMidiID == 126 {
                clipSlot.midiIn_wasQueued()
            }
            
            if clipStateMidiID == 120 {
                clipSlot.midiIn_wasRecordingStarted()
            }
        }
        
    }
}

// MARK: - CLIP COLOR
struct SL_SysExColorPacket: SL_MidiInputPacket {
    
    /// We just consider the first "getPacketLength" integers
    var packetContent: ArraySlice<UInt8>
    
    func getPacketLength() -> Int {
        return 7
    }
    
    func triggerPacketAction() {
        
        let startIndex = packetContent.startIndex
        
        // Validate Header
        guard self.packetContent.indices.contains(startIndex) else { return }
        guard self.packetContent[startIndex] == 0xF0 else { return }
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 1)) else { return }
        guard self.packetContent[startIndex.advanced(by: 1)] == 0 else { return }
        
        // Extract Content
        guard self.packetContent.indices.contains(startIndex.advanced(by: 2)) else { return }
        let note = self.packetContent[startIndex.advanced(by: 2)]
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 3)) else { return }
        let red = self.packetContent[startIndex.advanced(by: 3)]
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 4)) else { return }
        let green = self.packetContent[startIndex.advanced(by: 4)]
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 5)) else { return }
        let blue = self.packetContent[startIndex.advanced(by: 5)]
        
        // Validate Tail
        guard self.packetContent.indices.contains(startIndex.advanced(by: 6)) else { return }
        guard self.packetContent[startIndex.advanced(by: 6)] == 0xF7 else { return }
        
        // Multiply colors by two to compensate reduction to 7 bit for sending over SysEx
        updateClipColor(note, red*2, green*2, blue*2)
    }
    
    private func updateClipColor(_ clipID: UInt8, _ red: UInt8, _ green: UInt8, _ blue: UInt8) {
        guard let clipSlot = LiveSessionManager.shared.findClipSlot(midiNoteID: Int(clipID)) else { return }
        
        DispatchQueue.main.async {
            clipSlot.midiIn_wasColorChanged(Int(red), Int(green), Int(blue))
        }
        
    }
}

// MARK: - CLIP PRESENCE
struct SL_SysExPresencePacket: SL_MidiInputPacket {
    
    /// We just consider the first "getPacketLength" integers
    var packetContent: ArraySlice<UInt8>
    
    func getPacketLength() -> Int {
        return 5
    }
    
    func triggerPacketAction() {
        
        let startIndex = packetContent.startIndex
        
        // Validate Header
        guard self.packetContent.indices.contains(startIndex) else { return }
        guard self.packetContent[startIndex] == 0xF0 else { return }
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 1)) else { return }
        guard self.packetContent[startIndex.advanced(by: 1)] == 1 else { return }
        
        // Extract Content
        guard self.packetContent.indices.contains(startIndex.advanced(by: 2)) else { return }
        let note = self.packetContent[startIndex.advanced(by: 2)]
        
        guard self.packetContent.indices.contains(startIndex.advanced(by: 3)) else { return }
        let isPresent = self.packetContent[startIndex.advanced(by: 3)]
        
        // Validate Tail
        guard self.packetContent.indices.contains(startIndex.advanced(by: 4)) else { return }
        guard self.packetContent[startIndex.advanced(by: 4)] == 0xF7 else { return }
        
        updateClipPresence(note, isPresent)
    }
    
    private func updateClipPresence(_ clipID: UInt8, _ presenceBit: UInt8) {
        guard let clipSlot = LiveSessionManager.shared.findClipSlot(midiNoteID: Int(clipID)) else { return }
        
        DispatchQueue.main.async {
            if presenceBit == 0 {
                clipSlot.midiIn_wasClipRemoved()
            }
            if presenceBit == 1 {
                clipSlot.midiIn_wasClipAdded()
            }
        }
        
    }
}
