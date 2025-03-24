//
//  Bilan.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

struct Bilan: Codable {
    var id : String?
    var vendeurId: String
    var sommeDues: Double
    var totalFrais: Double
    var totalCommissions: Double
    var gains: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vendeurId, sommeDues, totalFrais, totalCommissions, gains
    }
}
