//
//  ObjectTrackingManager.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 03.04.2025.
//

import Foundation
import ARKit
import RealityKit

class ObjectTrackingManager {
    
    // MARK: - SINGLETON
    static var shared = ObjectTrackingManager()
    private init(){
        
    }
    
    // MARK: - TRACKING PROVIDER
    var provider: ObjectTrackingProvider?
    func startProvider() async -> ObjectTrackingProvider {
        let referenceObjects = ReferenceObjectLoader.shared.referenceObjects
        let trackingProvider = ObjectTrackingProvider(referenceObjects: referenceObjects)
        self.provider = trackingProvider
        return trackingProvider
    }
    
    // MARK: - STATE
    // String ID refers to the referenceObjectName
    private(set) var trackedLoopSources: [String: LoopSourceEntity] = [:]
    func addLoopSource(loopSource: LoopSourceEntity, with configuration: LoopSourceConfiguration) {
        trackedLoopSources[configuration.referenceObjectName] = loopSource
    }
    
    // MARK: - UPDATE
    @MainActor
    func processAnchorUpdates() async {
        guard let trackingProvider = ObjectTrackingManager.shared.provider else {
            return
        }
        
        for await anchorUpdate in trackingProvider.anchorUpdates {
            guard anchorUpdate.event == .updated else { continue }
            let associatedReferenceObject = anchorUpdate.anchor.referenceObject.name
            guard anchorUpdate.anchor.isTracked else { continue }
            trackedLoopSources[associatedReferenceObject]?.transform = Transform(matrix: anchorUpdate.anchor.originFromAnchorTransform)
        }
        
    }
}
