//
//  FactureViewModel.swift
//  FestiMobile
//
//  Created by Zolan Givre on 25/03/2025.
//


import Foundation
import SwiftUI

class FactureViewModel: ObservableObject {
    @Published var factureData: Data?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiUrl = "https://your-api-url.com/api/factures" // Remplace par l'URL de ton API

    // Fonction pour télécharger la facture depuis l'API
    func telechargerFacture(venteId: String) {
        isLoading = true
        errorMessage = nil
        factureData = nil
        
        guard let url = URL(string: "\(apiUrl)/\(venteId)/telechargerFacture") else {
            self.errorMessage = "URL invalide."
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/pdf", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur de réseau: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.errorMessage = "Aucune donnée reçue."
                }
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.factureData = data // On sauvegarde la donnée PDF
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur lors du téléchargement. Statut: \(response.statusCode)"
                }
            }
        }

        task.resume()
    }

    // Fonction pour sauvegarder le PDF localement (facultatif)
    func sauvegarderFacture() {
        guard let factureData = factureData else {
            errorMessage = "Aucune facture à sauvegarder."
            return
        }

        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else {
            errorMessage = "Répertoire de documents introuvable."
            return
        }
        
        let fileURL = documentDirectory.appendingPathComponent("facture.pdf")
        
        do {
            try factureData.write(to: fileURL)
            errorMessage = nil // Clear any previous error messages
        } catch {
            errorMessage = "Erreur lors de la sauvegarde de la facture: \(error.localizedDescription)"
        }
    }
}
