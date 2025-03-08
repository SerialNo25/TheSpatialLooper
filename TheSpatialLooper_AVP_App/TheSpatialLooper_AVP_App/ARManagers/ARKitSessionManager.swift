//
//  ARKitSessionManager.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

import Foundation
import ARKit

@MainActor
@Observable
class ARKitSessionManager {
    
    // MARK: - SINGLETON
    public static let shared = ARKitSessionManager()
    private init() {}
    
    
    // MARK: - AR SESSION
    var arkitSession = ARKitSession()
    func stopSession() {
        arkitSession.stop()
    }
    
    func runSession() async {
        do {
            try await arkitSession.run(
                [
                    WorldTrackingProvider(),
                    HandTrackingManager.shared.startProvider()
                ]
            )
        } catch {
            fatalError("Something went wrong with the ARKit Session")
        }
    }
}
