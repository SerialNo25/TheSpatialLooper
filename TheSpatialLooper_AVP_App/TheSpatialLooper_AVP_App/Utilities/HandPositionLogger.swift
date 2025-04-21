//
//  HandPositionLogger.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 21.04.2025.
//

import Foundation
import RealityKit

class HandPositionLogger {
    var loggerName: String
    private var log: [HandPositionDataPoint]
    
    init(loggerName: String) {
        self.loggerName = loggerName
        self.log = []
    }
    
    func logPosition (_ dataPoint: HandPositionDataPoint) {
        log.append(dataPoint)
    }
    
    func logPosition(entity: Entity) {
        self.logPosition(HandPositionDataPoint(posX: entity.position(relativeTo: nil).x, posY: entity.position(relativeTo: nil).y, posZ: entity.position(relativeTo: nil).z))
    }
    
    func exportLog() -> URL {

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(loggerName)_dataExport.csv")
        
        var output = "x,y,z\n"
        output += log.map {
            "\($0.posX),\($0.posY),\($0.posZ)"
        }.joined(separator: "\n")

        do {
            try output.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            fatalError("Export Failed")
        }
    }
}

struct HandPositionDataPoint {
    var posX: Float
    var posY: Float
    var posZ: Float
}
