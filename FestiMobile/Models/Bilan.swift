//
//  Bilan.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

struct Bilan: Codable {
    var vendeurId: String
    var sommeDues: Double
    var totalFrais: Double
    var totalCommissions: Double
    var gains: Double
}
