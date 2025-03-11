//
//  LoopSourceEntity.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import Foundation
import RealityKit
import ARKit

class LoopSourceEntity: Entity {
    
    // MARK: - SETUP
    
    var linkedTrack: SessionTrack?
    
    /// Recommended init for this class
    init(sourceName: String, track: SessionTrack, boundingBoxX: Float, boundingBoxY: Float, boundingBoxZ: Float, boundingBoxOffsetX: Float = 0, boundingBoxOffsetY: Float = 0, boundingBoxOffsetZ: Float = 0) {
        self.boundingBox = Self.createBoundingBox(dimx: boundingBoxX, dimy: boundingBoxY, dimz: boundingBoxZ)
        
        super.init()
        self.components.set(LoopSourceEntityComponent(loopSourceEntity: self))
        self.boundingBox.position = SIMD3<Float>(x: boundingBoxOffsetX, y: boundingBoxOffsetY, z: boundingBoxOffsetZ)
        self.addChild(boundingBox)
        
        self.setName(name: sourceName)
        self.setTrack(track: track)
        
        guard self.validateSetup() else { fatalError("Setup of: \(sourceName) failed. Ensure configration is complete")}
    }
    
    public required init() {
        self.boundingBox = Self.createBoundingBox(dimx: 0.1, dimy: 0.1, dimz: 0.1)
        
        super.init()
        self.components.set(LoopSourceEntityComponent(loopSourceEntity: self))
        self.addChild(boundingBox)
    }
    
    func setTrack(track: SessionTrack?) {
        linkedTrack = track
    }
    
    public func setName(name: String) {
        self.name = "LoopSourceEntity: \(name)"
        boundingBox.name = "\(name): BoundingBox"
    }
    
    public func validateSetup() -> Bool {
        guard linkedTrack != nil else { return false }
        guard self.name != "" else { return false }
        guard self.components[LoopSourceEntityComponent.self] != nil else { return false }
        return true
    }
    
    // MARK: - TRIGGER BOUNDING BOX
    let boundingBox: Entity
    
    static func createBoundingBox(dimx: Float, dimy: Float, dimz: Float) -> Entity {
        let boxShape = MeshResource.generateBox(size: .init(x: dimx, y: dimy, z: dimz))
        let boxModel = ModelEntity(mesh: boxShape, materials: [SimpleMaterial()])
        boxModel.components.set(OpacityComponent(opacity: 0.3))
        // collision needed for raycase with movement direction vector
        boxModel.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: .init(x: dimx, y: dimy, z: dimz))]))
        return boxModel
        
    }
    
    // MARK: - LoopControl
    
    private(set) var loopStarted: Bool = false
    private var triggerSource: LoopTriggerEntity? = nil
    
    // TODO: REMOVE MVP TEMP
    var clipNumber = 0
    
    func setLoopStarted(from trigger: LoopTriggerEntity) {
        // GUARDS
        guard !loopStarted else { return }
        // ensure this is only called from trigger
        guard trigger.activeLoop == self else { fatalError("Illegal call to LoopSourceEntity.setLoopStarted()") }
        self.triggerSource = trigger
        
        // visuals
        guard var modelComponent = self.boundingBox.components[ModelComponent.self] else { return }
        modelComponent.materials = [SimpleMaterial(color: .green, isMetallic: false)]
        self.boundingBox.components[ModelComponent.self] = modelComponent
        
        // loop
        MIDI_SessionManager.shared.sendMIDIMessage(MIDI_UMP_Packet.constructLoopTriggerMessage(clipSlotNumber: clipNumber))
        
        // state
        loopStarted = true
    }
    
    // TODO: add a feature that if the loop is stopped from ableton this (and the trigger) correctly reflect the state
    func setLoopStopped(from trigger: LoopTriggerEntity) {
        // GUARDS
        guard loopStarted else { return }
        // ensure only the linked trigger can stop the loop
        guard trigger.activeLoop == self else { fatalError("Illegal call to LoopSourceEntity.setLoopStarted()") }
        guard self.triggerSource == trigger else { fatalError("Illegal call to LoopSourceEntity.setLoopStarted()") }
        self.triggerSource = nil
        
        // visuals
        guard var modelComponent = self.boundingBox.components[ModelComponent.self] else { return }
        modelComponent.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        self.boundingBox.components[ModelComponent.self] = modelComponent
        
        // loop
        MIDI_SessionManager.shared.sendMIDIMessage(MIDI_UMP_Packet.constructLoopTriggerMessage(clipSlotNumber: clipNumber))
        self.clipNumber += 1
        
        // state
        loopStarted = false
    }
    
}
