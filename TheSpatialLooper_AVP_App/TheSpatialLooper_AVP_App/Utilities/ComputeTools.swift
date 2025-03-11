//
//  ComputeTools.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 09.03.2025.
//

import Foundation

extension Int {
    func clamp(minValue: Int, maxValue: Int) -> Int {
        return Swift.min(Swift.max(minValue,self),maxValue)
    }
}
