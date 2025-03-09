//
//  MIDI_SessionManager.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 09.03.2025.
//

import CoreMIDI

class MIDI_SessionManager: ObservableObject {
    
    let session = MIDINetworkSession.default()
    var client = MIDIClientRef()
    var midiOutputPort = MIDIPortRef()
    var midiInputPort = MIDIPortRef()
    
    // MARK: - SINGLETON
    public static let shared = MIDI_SessionManager()
    private init() {
        
        MIDIClientCreate("SpatialLooper_MIDICLIENT" as CFString, nil, nil, &client)
        
        MIDIOutputPortCreate(client, "SpatialLooper_MIDIOUTPUTPORT" as CFString, &midiOutputPort)
        // TODO: Implement callback
        MIDIInputPortCreate(client, "SpatialLooper_MIDIINPUTPORT" as CFString, { _,_,_ in return}, nil, &midiInputPort)
        
    }
    
    // MARK: - SESSION MANAGEMENT
    var sessionActive: Bool {
        get {
            session.isEnabled
        }
    }
    
    @Published var connectedSource: MIDIEndpointRef?
    @Published var connectedDestination: MIDIEndpointRef?
    var isConnected: Bool {
        get {
            return connectedSource != nil && connectedDestination != nil
        }
    }
    
    func enableSession() {
        session.isEnabled = true
        session.connectionPolicy = .anyone
    }
    
    func disableSession() {
        session.isEnabled = false
        connectedSource = nil
    }
    
    func connectSession() {
        let midiSource = MIDIGetSource(0)
        let midiDestination = MIDIGetDestination(0)
        guard midiSource != 0 else { return }
        guard midiDestination != 0 else { return }
        
        MIDIPortConnectSource(midiInputPort, midiSource, nil)
        
        connectedSource = midiSource
        connectedDestination = midiDestination
    }
    
    // MARK: - MIDI SENDING
    @Published private(set) var midiChannel: Int = 0
    func setMidiChannel(_ channel: Int) {
        midiChannel = channel.clamp(minValue: 0, maxValue: 15)
    }
    
    func sendMIDIMessage(messageType: MIDI_MessageType, message: [UInt8]) {
        guard let destination = connectedDestination else {return}
        
        let fullMessage = [constructMessageHeader(midiMessageType: messageType)] + message
        
        // TODO: Update this to non deprecated tools
        var packetList = MIDIPacketList()
        var packet = MIDIPacketListInit(&packetList)
        packet = MIDIPacketListAdd(&packetList, 1024, packet, 0, fullMessage.count, fullMessage)
        
        MIDISend(midiOutputPort, destination, &packetList)
    }
    
    private func constructMessageHeader(midiMessageType: MIDI_MessageType) -> UInt8 {
        return UInt8(midiMessageType.rawValue + midiChannel)
    }
    
    
    
    
}

// implemented after: https://ccrma.stanford.edu/~craig/articles/linuxmidi/misc/essenmidi.html
enum MIDI_MessageType: Int {
    case noteOff = 0x80
    case noteOn = 0x90
}
