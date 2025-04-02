//
//  LoopSourceEntity.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI

class LoopSourceEntity: Entity {
    
    // MARK: - SETUP
    
    var linkedTrack: LiveSessionTrack?
    
    var linkedSessionTrackView: ViewAttachmentEntity?
    
    /// Recommended init for this class
    init(sourceName: String, track: LiveSessionTrack, boundingBoxX: Float, boundingBoxY: Float, boundingBoxZ: Float, boundingBoxOffsetX: Float = 0, boundingBoxOffsetY: Float = 0, boundingBoxOffsetZ: Float = 0) {
        self.boundingBox = Self.createBoundingBox(dimx: boundingBoxX, dimy: boundingBoxY, dimz: boundingBoxZ)
        
        super.init()
        self.components.set(LoopSourceEntityComponent(loopSourceEntity: self))
        self.boundingBox.position = SIMD3<Float>(x: boundingBoxOffsetX, y: boundingBoxOffsetY, z: boundingBoxOffsetZ)
        self.addChild(boundingBox)
        
        self.setName(name: sourceName)
        self.setTrack(track: track)
    }
    
    public required init() {
        self.boundingBox = Self.createBoundingBox(dimx: 0.1, dimy: 0.1, dimz: 0.1)
        
        super.init()
        self.components.set(LoopSourceEntityComponent(loopSourceEntity: self))
        self.addChild(boundingBox)
    }
    
    public func setSessionTrakView(sessionTrackView: ViewAttachmentEntity, horizontalOffset: Float = 0, verticalOffset: Float = 0, depthOffset: Float = 0) {
        self.linkedSessionTrackView = sessionTrackView
        sessionTrackView.transform.translation = sessionTrackView.transform.translation + SIMD3<Float>(horizontalOffset, verticalOffset, depthOffset)
        sessionTrackView.orientation = simd_quatf(angle: -0.4, axis: SIMD3<Float>(1, 0, 0)) * sessionTrackView.orientation
        self.addChild(sessionTrackView)
    }
    
    func setTrack(track: LiveSessionTrack?) {
        linkedTrack = track
    }
    
    public func setName(name: String) {
        self.name = "LoopSourceEntity: \(name)"
        boundingBox.name = "\(name): BoundingBox"
    }
    
    public func validateSetup() -> Bool {
        guard linkedSessionTrackView != nil else { return false }
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
    
    private(set) var loopIsRecording: Bool = false
    
    private(set) var triggersInUse: Set<LoopTriggerEntity> = []
    
    // BOUNDING BOX
    func triggerEnteredBoundingBox(trigger: LoopTriggerEntity) {
        
        // INV: trigger not already linked
        guard !triggersInUse.contains(trigger) else { return }
        // INV: valid trigger
        guard trigger.activeLoopSource == self else { fatalError("Illegal call to LoopSourceEntity.setLoopStarted()") }
        
        triggersInUse.insert(trigger)
        
        if !loopIsRecording {
            startLoopRecording()
            guard loopIsRecording else { fatalError("startLoopRecording failed") }
        }
        
        
    }
    
    func triggerLeftBoundingBox(trigger: LoopTriggerEntity) {
        guard triggersInUse.contains(trigger) else { return }
        
        triggersInUse.remove(trigger)
        
        if triggersInUse.isEmpty && loopIsRecording {
            stopLoopRecording()
            guard !loopIsRecording else { fatalError("stopLoopRecording failed") }
        }
    }
    
    // TRACK CONTROL
    func commitLoop() {
        guard loopIsRecording else { return }
        
        // visuals
        guard var modelComponent = self.boundingBox.components[ModelComponent.self] else { return }
        modelComponent.materials = [SimpleMaterial(color: .purple, isMetallic: false)]
        self.boundingBox.components[ModelComponent.self] = modelComponent
        
        // loop
        guard let track = self.linkedTrack else { return }
        track.stopRecording()
        
        loopIsRecording = false
        
    }
    
    func startLoopRecording() {
        // GUARDS
        guard !loopIsRecording else { return }
        
        // visuals
        guard var modelComponent = self.boundingBox.components[ModelComponent.self] else { return }
        modelComponent.materials = [SimpleMaterial(color: .green, isMetallic: false)]
        self.boundingBox.components[ModelComponent.self] = modelComponent
        
        // loop
        guard let track = self.linkedTrack else { return }
        track.startRecording()
        
        // state
        loopIsRecording = true
    }
    
    func stopLoopRecording() {
        // GUARDS
        guard loopIsRecording else { return }
        guard self.triggersInUse.isEmpty else { return }
        
        // visuals
        guard var modelComponent = self.boundingBox.components[ModelComponent.self] else { return }
        modelComponent.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        self.boundingBox.components[ModelComponent.self] = modelComponent
        
        // loop
        guard let track = self.linkedTrack else { return }
        track.cancelRecording()
        
        // state
        loopIsRecording = false
    }
    
}
