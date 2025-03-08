//
//  FaceHeadsetSystem.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 08.03.2025.
//

import Foundation
import RealityKit

class FaceHeadsetSystem: System {
    required init(scene: Scene) {
        
    }
    
    private let targetQuery = EntityQuery(where: .has(FaceHeadsetComponent.self))
    
    func update(context: SceneUpdateContext) {
        
        guard let deviceAnchor = ARKitSessionManager.shared.queryDeviceAnchor() else { return }
        guard deviceAnchor.isTracked else { return }
        
        let targets = context.entities(matching: targetQuery, updatingSystemWhen: .rendering)
        
        for target in targets {
            target.look(at:
                            [
                                deviceAnchor.originFromAnchorTransform.columns.3.x,
                                deviceAnchor.originFromAnchorTransform.columns.3.y,
                                deviceAnchor.originFromAnchorTransform.columns.3.z
                            ],
                        from: target.position (relativeTo: nil),
                        relativeTo: nil, forward: .positiveZ
            )
        }
        
    }
}
