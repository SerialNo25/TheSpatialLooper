//
//  ARKitSessionManager.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

import Foundation
import QuartzCore
import ARKit

@MainActor
@Observable
class ARKitSessionManager {
    
    // MARK: - SINGLETON
    public static let shared = ARKitSessionManager()
    private init() {}
    
    
    // MARK: - AR SESSION
    private var arkitSession = ARKitSession()
    private var worldTracking = WorldTrackingProvider()
    
    func stopSession() {
        arkitSession.stop()
    }
    
    func runSession() async {
        worldTracking = WorldTrackingProvider()
        do {
            try await arkitSession.run(
                [
                    worldTracking,
                    HandTrackingManager.shared.startProvider()
                ]
            )
        } catch {
            fatalError("Something went wrong with the ARKit Session")
        }
    }
    
    func queryDeviceAnchor() -> DeviceAnchor? {
        return worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())
    }
}
