//
//  GlobalConfig.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 06.03.2025.
//

import Foundation

enum GlobalConfig {
    // MARK: - DEVELOPER MODES
    static let SHOW_HAND_TRACKING_JOINTS = false
    static let SHOW_BOUNDING_BOXES = false
    
    // MARK: - DEV LOGGING
    static let LOGGING_ACTIVE = false
    static let LOGGING_INTERVAL: Double = 2
    
    // MARK: - SESSION CONFIG
    static let LOOP_GRID_WIDTH: Int = 5
    static let LOOP_GRID_HEIGHT: Int = 10
    
    // MARK: - TRACK CONFIG
    // NOTE: The Reference Object Name is mapped to the tracker AND filename. It is required that the name AND filename match the internal name of the tracker.
    static let LOOP_SOURCE_CONFIGURATIONS: [LoopSourceConfiguration] = [
        LoopSourceConfiguration(sourceName: "TR-8S", trackID: 3, boundingBoxX: 0.40, boundingBoxY: 0.12, boundingBoxZ: 0.3, boundingBoxOffsetY: 0.0, boundingBoxOffsetZ: 0.05, viewAttachmentHorizontalOffset: 0.1, viewAttachmentVerticalOffset: 0.1, viewAttachmentDepthOffset: -0.1, referenceObjectName: "TR-8S_Scaled"),
//        LoopSourceConfiguration(sourceName: "TEO-5", trackID: 1, boundingBoxX: 0.64, boundingBoxY: 0.17, boundingBoxZ: 0.4, boundingBoxOffsetY: 0.07, boundingBoxOffsetZ: 0.08, viewAttachmentVerticalOffset: 0.2, referenceObjectName: "OberheimScaled"),
        LoopSourceConfiguration(sourceName: "NordStage3", trackID: 1, boundingBoxX: 1.3, boundingBoxY: 0.17, boundingBoxZ: 0.3, boundingBoxOffsetX: 0.05, boundingBoxOffsetY: 0.1, boundingBoxOffsetZ: 0.26, viewAttachmentVerticalOffset: 0.2, referenceObjectName: "nord"),
        LoopSourceConfiguration(sourceName: "Fantom06", trackID: 0, boundingBoxX: 1, boundingBoxY: 0.17, boundingBoxZ: 0.34, boundingBoxOffsetY: 0.08, boundingBoxOffsetZ: 0.1, viewAttachmentVerticalOffset: 0.2, referenceObjectName: "Fantom"),
        LoopSourceConfiguration(sourceName: "MS-20", trackID: 2, boundingBoxX: 0.6, boundingBoxY: 0.3, boundingBoxZ: 0.3, boundingBoxOffsetY: 0.23, boundingBoxOffsetZ: 0.15, viewAttachmentVerticalOffset: 0.4, referenceObjectName: "MS-20")
    ]
    
    // MARK: - CONTROL CONFIG
    static let DETECTED_GESTURE_MAX_DURATION: TimeInterval = 0.3
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
