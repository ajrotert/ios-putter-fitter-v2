//
//  PutterCharacteristics.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/24/22.
//

import Foundation

class PutterCharacteristics {
    
    public var importance: Int
    public var trait: String

    init(importance: Int, trait: String) {
        self.importance = importance
        self.trait = trait
    }
}
