//
//  PositionLoggingSystem.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 21.04.2025.
//

import Foundation
import RealityKit

class PositionLoggingSystem: System {
    
    private var lastExecution = Date()
    
    required init(scene: Scene) {
        
    }
    
    private let targetQuery = EntityQuery(where: .has(PositionLoggingComponent.self))
    
    func update(context: SceneUpdateContext) {
        
        guard GlobalConfig.LOGGING_ACTIVE else { return }
        guard abs(lastExecution.timeIntervalSinceNow) > GlobalConfig.LOGGING_INTERVAL else { return }
        
        let loggableEntities = context.entities(matching: targetQuery, updatingSystemWhen: .rendering)
        
        for loggable in loggableEntities {
            guard let loggingComponent = loggable.components[PositionLoggingComponent.self] else { continue }
            loggingComponent.logger.logPosition(entity: loggable)
            lastExecution = Date()
            
        }
        
    }
    
}
