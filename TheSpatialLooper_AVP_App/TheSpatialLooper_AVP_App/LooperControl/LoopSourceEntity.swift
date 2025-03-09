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
    
    func setLoopStarted() {
        guard !loopStarted else { return }
        guard var modelComponent = self.boundingBox.components[ModelComponent.self] else { return }
        modelComponent.materials = [SimpleMaterial(color: .green, isMetallic: false)]
        self.boundingBox.components[ModelComponent.self] = modelComponent
        loopStarted = true
    }
    
    func setLoopStopped() {
        guard loopStarted else { return }
        guard var modelComponent = self.boundingBox.components[ModelComponent.self] else { return }
        modelComponent.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        self.boundingBox.components[ModelComponent.self] = modelComponent
        loopStarted = false
    }
    
}
