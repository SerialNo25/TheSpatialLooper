//
//  WristFlickGestureSystem.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 07.04.2025.
//

import Foundation
import RealityKit

class WristFlickGestureSystem: System {
    required init(scene: Scene) {
        
    }
    
    private let targetQuery = EntityQuery(where: .has(FlickGestureComponent.self))
    
    func update(context: SceneUpdateContext) {
        
        let loopTriggers = context.entities(matching: targetQuery, updatingSystemWhen: .rendering)
        
        for trigger in loopTriggers {
            guard var triggerComponent = trigger.components[FlickGestureComponent.self] else { continue }
            
            
            let referenceEntity = triggerComponent.referenceJoint
            let yAxis = SIMD3<Float>(0, 1, 0)
            let recordingViewOrientationFromUp = referenceEntity.orientation.act(yAxis)
            let angleFromUpwardsY = acos(simd_dot(recordingViewOrientationFromUp, yAxis))
            let jointState = FlickGestureReferenceJointState.fromAngle(angle: angleFromUpwardsY)
            
            if triggerComponent.currentJointState != jointState {
                triggerComponent.updateJointState(with: jointState)
                trigger.components.set(triggerComponent)
                if triggerComponent.checkFlickGesture() {
                    triggerComponent.flickAction()
                }
            }
            
            
            
        }
        
    }
    
}
