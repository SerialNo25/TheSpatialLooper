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
        MIDIInputPortCreate(client, "SpatialLooper_MIDIINPUTPORT" as CFString, { pktlist, refCon, srcConnRefCon in MIDI_SessionManager.receiveMIDIMessage(pktlist, refCon, srcConnRefCon)}, nil, &midiInputPort)
        
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
    
    func sendMIDIMessage(_ message: MIDI_UMP_Packet) {
        guard let destination = connectedDestination else {return}
        
        var eventList = MIDIEventList()
        var packet = MIDIEventListInit(&eventList, ._1_0)
        packet = MIDIEventListAdd(&eventList, 1024, packet, 0, message.content.count, message.content)
        
        MIDISendEventList(midiOutputPort, destination, &eventList)
        
    }
    
    // MARK: - MIDI RECEIVING
    static func receiveMIDIMessage(_ pktlist: UnsafePointer<MIDIPacketList>, _ refCon: Optional<UnsafeMutableRawPointer>, _ srcConnRefCon: Optional<UnsafeMutableRawPointer>){
        
        let packetList = pktlist.pointee
        var packet = packetList.packet
        
        for _ in 0..<packetList.numPackets {
            
            let packetData = packet.data
            let packetLength = packet.length
            
            guard let packetDataArray = Mirror(reflecting: packetData).children.map(\.value) as? Array<UInt8> else {continue}
            
            MIDI_InputManager.shared.handleInputPacket(packetDataArray)
            print("Received MIDI Packet: \(packetDataArray.prefix(Int(packetLength)))")
            
            packet = MIDIPacketNext(&packet).pointee
        }
        
    }
    
    
}
