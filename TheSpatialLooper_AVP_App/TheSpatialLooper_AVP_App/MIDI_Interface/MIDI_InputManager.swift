//
//  MIDI_InputManager.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 23.03.2025.
//

import Foundation

class MIDI_InputManager {
    
    // MARK: - SINGLETON
    public static let shared = MIDI_InputManager()
    private init() {}
    
    func handleInputPacket(_ packet: Array<UInt8>) {
        
        var readerPosition = 0
        
        while packet.indices.contains(readerPosition) {
            let prefix = packet[readerPosition]
            var packetObject: SL_MidiInputPacket?
            
            let slicedPacket = packet[readerPosition...]
            if prefix == 144 {
                packetObject = SL_ClipStatePacket(packetContent: slicedPacket)
            }
            
            if prefix == 0xF0 {
                guard packet.indices.contains(readerPosition + 1) else { return }
                let sysExPrefix = packet[readerPosition + 1]
                if sysExPrefix == 0 {
                    packetObject = SL_SysExColorPacket(packetContent: slicedPacket)
                }
                if sysExPrefix == 1 {
                    packetObject = SL_SysExPresencePacket(packetContent: slicedPacket)
                }
            }
            
            guard let packetObject = packetObject else { return }
            
            packetObject.triggerPacketAction()
            
            guard packetObject.getPacketLength() > 0 else { return }
            readerPosition += packetObject.getPacketLength()
        }
        
        
        
    }
    
    
    
    
    
}
