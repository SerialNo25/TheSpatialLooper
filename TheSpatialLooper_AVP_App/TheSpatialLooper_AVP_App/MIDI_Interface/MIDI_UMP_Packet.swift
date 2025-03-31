//
//  MIDI_UMP_Packet.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 10.03.2025.
//

import Foundation

struct MIDI_UMP_Packet {
    
    static let REQUEST_NOTE_UPDATE_NOTE_VAUE: UInt8 = 110
    
    // Construct midi UMP packet header. The following documentation from MIDI Association was used to create this: https://drive.google.com/file/d/1l2L5ALHj4K9hw_LalQ2jJZBMXDxc9Uel/view
    var content: [UInt32]
    private init(content: [UInt32]){
        self.content = content
    }
    
    // MARK: - Standard Packets
    static func construct_1_0_ChannelVoiceMessage(midiMessageType: MIDI_MessageType, midiChannel: Int, byte1: UInt8, byte2: UInt8) -> MIDI_UMP_Packet {
        
        let msgType = 0x20 << 24
        let status = midiMessageType.rawValue << 16
        let channel = midiChannel << 16
        let b1 = Int(byte1) << 8
        let b2 = Int(byte2)
        
        let word = UInt32(msgType + status + channel + b1 + b2)
        
        let packet = MIDI_UMP_Packet(content: [word])
        
        return packet
    }
    
    // MARK: - Taylored Packets
    // TODO: Implement Track Selection
    static func constructLoopTriggerMessage(clipSlotNumber: Int) -> MIDI_UMP_Packet {
        return Self.construct_1_0_ChannelVoiceMessage(midiMessageType: .noteOn, midiChannel: MIDI_SessionManager.shared.midiChannel, byte1: UInt8(clipSlotNumber), byte2: 127)
    }
    
    static func constructStatusUpdateRequestMessage() -> MIDI_UMP_Packet {
        return Self.construct_1_0_ChannelVoiceMessage(midiMessageType: .noteOn, midiChannel: MIDI_SessionManager.shared.midiChannel, byte1: REQUEST_NOTE_UPDATE_NOTE_VAUE, byte2: 127)
    }

    
}


// implemented after: https://ccrma.stanford.edu/~craig/articles/linuxmidi/misc/essenmidi.html
enum MIDI_MessageType: Int {
    case noteOff = 0x80
    case noteOn = 0x90
}

