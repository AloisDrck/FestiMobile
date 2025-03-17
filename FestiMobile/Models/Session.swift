//
//  Session.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import Foundation

struct Session: Codable, Identifiable {
    var id: String?
    var dateDebut: Date
    var dateFin: Date
    var fraisDepot: Double
    var statutSession: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case dateDebut
        case dateFin
        case fraisDepot
        case statutSession
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Convertir l'ID en optionnel
        id = try container.decodeIfPresent(String.self, forKey: .id)

        // Formatter pour les dates avec millisecondes
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC

        // Convertir `dateDebut`
        let dateDebutString = try container.decode(String.self, forKey: .dateDebut)
        guard let parsedDateDebut = dateFormatter.date(from: dateDebutString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateDebut, in: container, debugDescription: "Format de date invalide : \(dateDebutString)")
        }
        self.dateDebut = parsedDateDebut

        // Convertir `dateFin`
        let dateFinString = try container.decode(String.self, forKey: .dateFin)
        guard let parsedDateFin = dateFormatter.date(from: dateFinString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateFin, in: container, debugDescription: "Format de date invalide : \(dateFinString)")
        }
        self.dateFin = parsedDateFin

        // Frais de dépôt
        self.fraisDepot = try container.decode(Double.self, forKey: .fraisDepot)

        // Statut
        self.statutSession = try container.decode(String.self, forKey: .statutSession)
    }
}
