//
//  LoopTriggerHand.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import Foundation
import RealityKit
import _RealityKit_SwiftUI
import ARKit

class LoopTriggerEntity: Entity, ObservableObject {
    
    // MARK: - SETUP
    private(set) var loopRecordingView: Entity?
    private(set) var handReferenceEntity: Entity?
    
    /// Recommended init for this class
    convenience init(triggerName: String, chirality: HandAnchor.Chirality) {
        self.init()
        let recordingViewReferenceJoint = HandSkeleton.JointName.wrist
        self.setName(name: triggerName)
        self.linkHand(handReferenceEntity: HandTrackingManager.shared.getJoint(chirality: chirality, joint: recordingViewReferenceJoint))
    }
    
    public required init() {
        super.init()
        self.components.set(LoopTriggerEntityComponent(loopTriggerEntity: self))
        self.components.set(
            CollisionComponent(shapes:
                                [ShapeResource.generateSphere(radius: 0.01)]
                              )
        )
        

    }
    
    public func setLoopRecordingView(loopRecordingView: ViewAttachmentEntity, horizontalAttachmentOffset: Float) {
        loopRecordingView.transform.translation = SIMD3<Float>(horizontalAttachmentOffset, 0.05, 0.02)
        let recordingViewAnchorEntity = Entity()
        recordingViewAnchorEntity.addChild(loopRecordingView)

        self.loopRecordingView = recordingViewAnchorEntity
        recordingViewAnchorEntity.components.set(FaceHeadsetComponent())
        self.addChild(recordingViewAnchorEntity)
    }
    
    public func setName(name: String) {
        self.name = "LoopTriggerEntity: \(name)"
        guard let viewAttachment = loopRecordingView else { return }
        viewAttachment.name = "\(name): ViewAttachment"
    }
    
    public func linkHand(handReferenceEntity: Entity) {
        self.handReferenceEntity = handReferenceEntity
        self.components.set(FlickGestureComponent(referenceJoint: handReferenceEntity, flickAction: self.toggleArm))
    }
    
    public func validateSetup() -> Bool {
        guard loopRecordingView != nil else { return false }
        guard handReferenceEntity != nil else { return false }
        guard self.name != "" else { return false }
        guard self.components[LoopTriggerEntityComponent.self] != nil else { return false }
        return true
    }
    
    public func attachToHand() {
        guard let hand = handReferenceEntity else { fatalError("Attempt to link a hand with incomplete setup. No linked hand reference available.") }
        hand.addChild(self)
    }
    
    // MARK: - LOOP CONTROL
    @Published var activeLoopSource: LoopSourceEntity?
    @Published var isArmed: Bool = false
    
    func toggleArm() {
        // only allow modifications while not in bounding box
        guard self.activeLoopSource == nil else { return }
        isArmed.toggle()
    }
    
    func enterBoundingBox(of source: LoopSourceEntity) {
        guard isArmed else { return }
        
        // leave any active bounding box before entering a new one
        if let currentlyLoopingSource = activeLoopSource {
            self.leaveBoundingBox(of: currentlyLoopingSource)
        }
        
        guard !source.triggersInUse.contains(self) else {return}
        self.activeLoopSource = source
        source.triggerEnteredBoundingBox(trigger: self)
        guard source.triggersInUse.contains(self) else { fatalError("Entering bounding box failed")}
    }
    
    func leaveBoundingBox(of source: LoopSourceEntity) {
        guard isArmed else { return }
        
        guard let currentlyLoopingSource = activeLoopSource else {return}
        // match the sourceEntity before leaving
        guard currentlyLoopingSource == source else {return}
                
        guard currentlyLoopingSource.triggersInUse.contains(self) else {return}
        currentlyLoopingSource.triggerLeftBoundingBox(trigger: self)
        self.activeLoopSource = nil
        guard !currentlyLoopingSource.triggersInUse.contains(self) else { fatalError("Leaving bounding box failed")}
    }
    
    func commitLoop() {
        guard isArmed else { return }
        
        guard let activeLoopSource = activeLoopSource else { return }
        activeLoopSource.commitLoop()
    }
    
    func discardLoop() {
        guard isArmed else { return }
        
        guard let activeLoopSource = activeLoopSource else { return }
        activeLoopSource.cancelLoopRecording()
    }
    
    func reStartLoop() {
        guard isArmed else { return }
        
        guard let activeLoopSource = activeLoopSource else { return }
        activeLoopSource.reStartLoop()
    }
}
