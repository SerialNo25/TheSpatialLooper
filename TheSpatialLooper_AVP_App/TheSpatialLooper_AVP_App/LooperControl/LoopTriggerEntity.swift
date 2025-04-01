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

class LoopTriggerEntity: Entity {
    
    // MARK: - SETUP
    private var loopRecordingView: ViewAttachmentEntity?
    private var handReferenceEntity: Entity?
    
    /// Recommended init for this class
    convenience init(viewAttachmentEntity: ViewAttachmentEntity, triggerName: String, chirality: HandAnchor.Chirality) {
        self.init()
        let recordingViewReferenceJoint = HandSkeleton.JointName.wrist
        self.setLoopRecordingView(loopRecordingView: viewAttachmentEntity)
        self.setName(name: triggerName)
        self.linkHand(handReferenceEntity: HandTrackingManager.shared.getJoint(chirality: chirality, joint: recordingViewReferenceJoint))
        
        guard self.validateSetup() else { fatalError("Setup of: \(triggerName) failed. Ensure configration is complete")}
    }
    
    public required init() {
        super.init()
        self.components.set(LoopTriggerEntityComponent(LoopTriggerEntity: self))
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
    
    // TODO: - Map this such that multiple triggers can map. -> Handover of active trigger instance must be possible. 
    
    var activeLoop: LoopSourceEntity?
    
    func startLooping(source: LoopSourceEntity) {
        self.activeLoop = source
        source.setLoopStarted(from: self)
    }
    
    func stopLooping() {
        guard let currentlyLoopingSource = activeLoop else {return}
        currentlyLoopingSource.setLoopStopped(from: self)
        self.activeLoop = nil
    }
}
