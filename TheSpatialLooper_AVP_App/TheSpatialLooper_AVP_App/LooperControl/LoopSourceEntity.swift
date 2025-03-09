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
    convenience init(sourceName: String, track: SessionTrack) {
        self.init()
        self.setName(name: sourceName)
        self.setTrack(track: track)
        
        guard self.validateSetup() else { fatalError("Setup of: \(sourceName) failed. Ensure configration is complete")}
    }
    
    public required init() {
        super.init()
        self.components.set(LoopSourceEntityComponent(LoopSourceEntity: self))
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
    let boundingBox: Entity = {
        let boxShape = MeshResource.generateBox(size: .init(x: 0.1, y: 0.1, z: 0.1))
        let boxModel = ModelEntity(mesh: boxShape, materials: [SimpleMaterial()])
        return boxModel
    }()
    
}
