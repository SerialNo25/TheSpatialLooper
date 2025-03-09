//
//  LoopTriggerSystem.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 09.03.2025.
//

import Foundation
import RealityKit

class LoopTriggerSystem: System {
    required init(scene: Scene) {
        
    }
    
    private let sourceQuery = EntityQuery(where: .has(LoopSourceEntityComponent.self))
    private let triggerQuery = EntityQuery(where: .has(LoopTriggerEntityComponent.self))
    
    func update(context: SceneUpdateContext) {
        
        let sources = context.entities(matching: sourceQuery, updatingSystemWhen: .rendering)
        let triggers = context.entities(matching: triggerQuery, updatingSystemWhen: .rendering)
        
        
        for source in sources {
            
            guard let sourceComponent = source.components[LoopSourceEntityComponent.self] else { continue }
            
            // TODO: Upgrade to raycasting for collision detection. Ray should be used in the direction of movement.
            // see: https://developer.apple.com/documentation/realitykit/scene/raycast(origin:direction:length:query:mask:relativeto:)
            for trigger in triggers {
                if simd_distance(source.position(relativeTo: nil), trigger.position(relativeTo: nil)) < 0.4 {
                    sourceComponent.loopSourceEntity.setLoopStarted()
                } else {
                    sourceComponent.loopSourceEntity.setLoopStopped()
                }
            }
        }
        
    }
}
