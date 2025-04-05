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
    private var loopRecordingView: ViewAttachmentEntity?
    private var handReferenceEntity: Entity?
    
    /// Recommended init for this class
    convenience init(triggerName: String, chirality: HandAnchor.Chirality) {
        self.init()
        let recordingViewReferenceJoint = HandSkeleton.JointName.wrist
        self.setName(name: triggerName)
        self.linkHand(handReferenceEntity: HandTrackingManager.shared.getJoint(chirality: chirality, joint: recordingViewReferenceJoint))
    }
    
    public required init() {
        super.init()
        self.components.set(LoopTriggerEntityComponent(LoopTriggerEntity: self))
        self.components.set(
            CollisionComponent(shapes:
                                [ShapeResource.generateSphere(radius: 0.01)]
                              )
        )
        

    }
    
    public func setLoopRecordingView(loopRecordingView: ViewAttachmentEntity) {
        self.loopRecordingView = loopRecordingView
        loopRecordingView.components.set(FaceHeadsetComponent())
        self.addChild(loopRecordingView)
    }
    
    public func setName(name: String) {
        self.name = "LoopTriggerEntity: \(name)"
        guard let viewAttachment = loopRecordingView else { return }
        viewAttachment.name = "\(name): ViewAttachment"
    }
    
    public func linkHand(handReferenceEntity: Entity) {
        self.handReferenceEntity = handReferenceEntity
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
    
    func enterBoundingBox(of source: LoopSourceEntity) {
        guard !source.triggersInUse.contains(self) else {return}
        self.activeLoopSource = source
        source.triggerEnteredBoundingBox(trigger: self)
        guard source.triggersInUse.contains(self) else { fatalError("Entering bounding box failed")}
    }
    
    func leaveBoundingBox() {
        guard let currentlyLoopingSource = activeLoopSource else {return}
        guard currentlyLoopingSource.triggersInUse.contains(self) else {return}
        currentlyLoopingSource.triggerLeftBoundingBox(trigger: self)
        self.activeLoopSource = nil
        guard !currentlyLoopingSource.triggersInUse.contains(self) else { fatalError("Leaving bounding box failed")}
    }
    
    func commitLoop() {
        guard let activeLoopSource = activeLoopSource else { return }
        activeLoopSource.commitLoop()
    }
    
    func reStartLoop() {
        guard let activeLoopSource = activeLoopSource else { return }
        activeLoopSource.reStartLoop()
    }
}
