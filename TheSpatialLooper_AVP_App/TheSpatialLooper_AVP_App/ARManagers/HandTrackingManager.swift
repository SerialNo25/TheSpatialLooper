//
//  HandTrackingManager.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

import ARKit
import RealityKit

@MainActor
class HandTrackingManager: ObservableObject {
    
    // MARK: - SINGLETON
    static var shared = HandTrackingManager()
    private init(){
        joints = [:]
        createJoints()
    }
    
    
    private(set) var joints: [JointHandTuple: ModelEntity]
    // convenience method for prettier syntax in other files :)
    func getJoint(chirality: HandAnchor.Chirality, joint: HandSkeleton.JointName) -> Entity {
        guard let joint = joints[JointHandTuple(chirality: chirality, joint: joint)] else {
            fatalError("Joint not found. Ensure the Manager setup was run and is correct")
        }
        return joint
    }
    
    
    // MARK: - TRACKING PROVIDER
    private var provider = HandTrackingProvider()
    func startProvider() -> HandTrackingProvider{
        provider = HandTrackingProvider()
        return provider
    }
    
    
    // MARK: - SETUP
    func createJoints() {
        for joint in HandSkeleton.JointName.allCases {
            for chirality in [HandAnchor.Chirality.left, HandAnchor.Chirality.right] {
                let jointTuple = JointHandTuple(chirality: chirality, joint: joint)
                joints[jointTuple] = createFingertip(name: "\(chirality.description): \(joint.description)")
            }
        }
    }
    
    func createFingertip(name: String) -> ModelEntity {
        
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.01),
            materials: [UnlitMaterial(color: .green.withAlphaComponent(GlobalConfig.SHOW_HAND_TRACKING_JOINTS ? 1 : 0))],
            collisionShape: .generateSphere(radius: 0.003),
            mass: 0.0
        )
        entity.components.set(PhysicsBodyComponent(mode: .kinematic))
        entity.name = name
        return entity
    }
    
    
    // MARK: - UPDATE
    func processHandUpdates() async {
        for await update in provider.anchorUpdates {
            let handAnchor = update.anchor
            guard handAnchor.isTracked else { continue }
            
            for joint in HandSkeleton.JointName.allCases {
                updateJointEntity(handAnchor: handAnchor, jointIdentifier: joint)
            }
        }
    }
    
    
    func updateJointEntity(handAnchor: HandAnchor, jointIdentifier: HandSkeleton.JointName) {
        guard let skeleton = handAnchor.handSkeleton else { return }
        let joint = skeleton.joint(jointIdentifier)
        guard (joint.isTracked) else { return }
        
        let handOriginTransform = handAnchor.originFromAnchorTransform
        let jointHandTransform = joint.anchorFromJointTransform
        
        if let jointEntity = joints[JointHandTuple(chirality: handAnchor.chirality, joint: jointIdentifier)] {
            jointEntity.setTransformMatrix(handOriginTransform * jointHandTransform, relativeTo: nil)
        }
    }
    
}


// MARK: - UTIL
struct JointHandTuple: Hashable {
    let chirality: HandAnchor.Chirality
    let joint: HandSkeleton.JointName
}

