//
//  FlickGestureComponent.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 07.04.2025.
//

import Foundation
import RealityKit

struct FlickGestureComponent: Component {
    
    let referenceJoint: Entity
    let flickAction: () -> Void
    
    // As the hand joints jump into position when initialiying we need to ignore the first 2 updates, else a gesture may be detected on init
    private var blockoutCounter: Int = 0
    private let blockoutThreshold: Int = 3
    private var isReady: Bool {
        return blockoutCounter >= blockoutThreshold
    }
    
    private var lastJointStateTimes: [FlickGestureReferenceJointState: Date]
    var currentJointState: FlickGestureReferenceJointState?
    
    init(referenceJoint: Entity, flickAction: @escaping () -> Void) {
        self.referenceJoint = referenceJoint
        self.lastJointStateTimes = [:]
        self.currentJointState = nil
        self.flickAction = flickAction
    }
    
    mutating func updateJointState(with jointState: FlickGestureReferenceJointState) {
        guard jointState != self.currentJointState else { return }
        self.currentJointState = jointState
        lastJointStateTimes[jointState] = Date()
        
        if blockoutCounter < blockoutThreshold {
            blockoutCounter += 1
        }
    }
    
    func checkFlickGesture() -> Bool {
        guard self.isReady else { return false }
        guard let lastDetectedUp = lastJointStateTimes[.up] else { return false }
        guard let lastDetectedDown = lastJointStateTimes[.down] else { return false }
        let now = Date()
        
        return abs(now.timeIntervalSince(lastDetectedUp)) < GlobalConfig.DETECTED_GESTURE_MAX_DURATION && abs(now.timeIntervalSince(lastDetectedDown)) < GlobalConfig.DETECTED_GESTURE_MAX_DURATION
    }
}

enum FlickGestureReferenceJointState {
    static let DOWN_THRESHOLD: Float = (7/12) * .pi
    static let UP_THRESHOLD: Float = (5/12) * .pi
    
    
    case down
    case up
    case side
    
    static func fromAngle(angle: Float) -> Self {
        if angle > Self.DOWN_THRESHOLD {
            return .down
        }
        if angle < Self.UP_THRESHOLD {
            return .up
        }
        return .side
    }
}
