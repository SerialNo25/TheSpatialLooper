//
//  CollisionEvent+SystemTypes.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 05.04.2025.
//

import Foundation
import RealityFoundation

extension CollisionEvents.Began {
    func handleTriggerEvent() {
        guard let loopParticipants = TriggerTypeExtractionUtility.extractLoopTriggerAndSource(entityA: self.entityA, entityB: self.entityB) else { return }
        loopParticipants.loopTrigger.enterBoundingBox(of: loopParticipants.loopSource)
    }
}

extension CollisionEvents.Ended {
    func handleTriggerEvent() {
        guard let loopParticipants = TriggerTypeExtractionUtility.extractLoopTriggerAndSource(entityA: self.entityA, entityB: self.entityB) else { return }
        loopParticipants.loopTrigger.leaveBoundingBox()
    }
}

enum TriggerTypeExtractionUtility {
    static func extractLoopTriggerAndSource(entityA: Entity, entityB: Entity) -> (loopSource: LoopSourceEntity, loopTrigger: LoopTriggerEntity)? {
        if type(of: entityA) == LoopTriggerEntity.self {
            guard let loopTriggerEntity = entityA as? LoopTriggerEntity else { return nil }
            // navigate from bounding box to parent source
            guard let loopSourceEntity = entityB.parent as? LoopSourceEntity else { return nil }
            return (loopSourceEntity, loopTriggerEntity)
        } else {
            // navigate from bounding box to parent source
            guard let loopSourceEntity = entityA.parent as? LoopSourceEntity else { return nil }
            guard let loopTriggerEntity = entityB as? LoopTriggerEntity else { return nil }
            return (loopSourceEntity, loopTriggerEntity)
        }
    }
}
