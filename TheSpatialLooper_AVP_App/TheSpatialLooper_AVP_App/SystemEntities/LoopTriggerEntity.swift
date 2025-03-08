//
//  LoopTriggerHand.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import Foundation
import RealityKit
import _RealityKit_SwiftUI

class LoopTriggerEntity: Entity {
    
    private var loopRecordingView: ViewAttachmentEntity?
    private var handReferenceEntity: Entity?
    
    public required init() {
        super.init()
        self.components.set(LoopTriggerEntityComponent())
    }
    
    public func setLoopRecordingView(loopRecordingView: ViewAttachmentEntity) {
        self.loopRecordingView = loopRecordingView
        loopRecordingView.components.set(FaceHeadsetComponent())
        self.addChild(loopRecordingView)
    }
    
    public func setName(name: String) {
        self.name = "LoopTriggerEntity: \(name)"
    }
    
    public func attachToHand(handReferenceEntity: Entity) {
        self.handReferenceEntity = handReferenceEntity
        handReferenceEntity.addChild(self)
    }
    
    public func validateSetup() -> Bool {
        guard loopRecordingView != nil else { return false }
        guard handReferenceEntity != nil else { return false }
        guard self.name != "" else { return false }
        guard self.components[LoopTriggerEntityComponent.self] != nil else { return false }
        return true
    }
}
