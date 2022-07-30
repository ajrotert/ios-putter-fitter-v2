//
//  PutterData.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/24/22.
//

import Foundation

class PutterData: Decodable {
    public var manufacturer: String?
    public var model: String?
    public var photoUrl: String?
    public var website: String?
    public var weights: String?
    
    private enum CodingKeys: CodingKey {
        case manufacturer
        case model
        case photoUrl
        case website
        case weights
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer)
        self.model = try container.decodeIfPresent(String.self, forKey: .model)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.website = try container.decodeIfPresent(String.self, forKey: .website)
        self.weights = try container.decodeIfPresent(String.self, forKey: .weights)
    }
}
