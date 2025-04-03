//
//  ReferenceObjectLoader.swift
//  TheSpatialLooper_AVP_App
//
//  Created by Flurin Selm on 03.04.2025.
//

import Foundation
import ARKit


final class ReferenceObjectLoader {
    
    // MARK: - SINGLETON
    static var shared = ReferenceObjectLoader()
    private init(){}
    
    // MARK: - LOGIC
    
    private var FILES: [String] {
        return GlobalConfig.LOOP_SOURCE_CONFIGURATIONS.map { $0.referenceObjectName + ".referenceobject" }
    }

    private(set) var referenceObjects = [ReferenceObject]()
    private var hasLoaded: Bool = false
    
    func load() async {
        
        guard !hasLoaded else { return }
        
        for file in self.FILES {
            let objectURL = Bundle.main.bundleURL.appending(path: file)
            Task {
                do {
                    var referenceObject: ReferenceObject
                    try await referenceObject = ReferenceObject(from: objectURL)
                    referenceObjects.append(referenceObject)
                } catch {
                    fatalError("Error on loading: \(objectURL): \(error)")
                }
            }
        }
        
        self.hasLoaded = true
    }
    
}
