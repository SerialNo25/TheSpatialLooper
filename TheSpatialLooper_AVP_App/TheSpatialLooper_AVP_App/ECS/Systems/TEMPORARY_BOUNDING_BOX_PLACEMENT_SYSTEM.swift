//
//  TEMPORARY_BOUNDING_BOX_PLACEMENT_SYSTEM.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 09.03.2025.
//

import Foundation
import RealityKit

class TEMPORARY_BOUNDING_BOX_PLACEMENT_SYSTEM: System {
    required init(scene: Scene) {
        
    }
    
    private let sourceQuery = EntityQuery(where: .has(LoopSourceEntityComponent.self))
    
    func update(context: SceneUpdateContext) {
        
        if AppState.shared.isPlacingBoundingBox {
            let sources = context.entities(matching: sourceQuery, updatingSystemWhen: .rendering)
            
            let hand = HandTrackingManager.shared.getJoint(chirality: .right, joint: .wrist)
            
            for source in sources {
                source.position = hand.position
                source.orientation = hand.orientation
            }
        }
        
    }
}
