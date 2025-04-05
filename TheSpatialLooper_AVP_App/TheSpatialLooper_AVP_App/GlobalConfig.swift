//
//  GlobalConfig.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

enum GlobalConfig {
    // MARK: - DEBUG MODES
    static let SHOW_HAND_TRACKING_JOINTS = true
    
    // MARK: - TRACK CONFIG
    // NOTE: The Reference Object Name is mapped to the tracker AND filename. It is required that the name AND filename match the internal name of the tracker.
    static let LOOP_SOURCE_CONFIGURATIONS: [LoopSourceConfiguration] = [
        LoopSourceConfiguration(sourceName: "TestSource", trackID: 0, boundingBoxX: 1, boundingBoxY: 0.1, boundingBoxZ: 0.5, boundingBoxOffsetZ: 0.1, viewAttachmentVerticalOffset: 0.2, referenceObjectName: "TR-8S_Scaled")
    ]
}

enum UIIdentifier {
    static let performanceSpace = "Performance Space"
}

struct LoopSourceConfiguration: Identifiable {
    var id: String { sourceName }
    
    let sourceName: String
    let trackID: Int
    let boundingBoxX: Float
    let boundingBoxY: Float
    let boundingBoxZ: Float
    var boundingBoxOffsetX: Float = 0
    var boundingBoxOffsetY: Float = 0
    var boundingBoxOffsetZ: Float = 0
    
    var viewAttachmentHorizontalOffset: Float = 0
    var viewAttachmentVerticalOffset: Float = 0
    var viewAttachmentDepthOffset: Float = 0
    
    var referenceObjectName: String
}
