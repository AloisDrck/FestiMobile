//
//  FactureService.swift
//  FestiMobile
//
//  Created by Zolan Givre on 25/03/2025.
//

import PDFKit
import Foundation

class FactureService {
    static func genererFacture(vente: Vente, jeuxVendus: [VenteJeu], utilisateurViewModel: UtilisateurViewModel, completion: @escaping (Data?, Error?) -> Void) {
        // Appel à getUserById pour récupérer l'acheteur et le vendeur
        let dispatchGroup = DispatchGroup()
        var acheteur: Utilisateur?
        var vendeur: Utilisateur?
        var errorMessage: String?
        
        // Récupérer l'acheteur
        dispatchGroup.enter()
        utilisateurViewModel.getUserById(id: vente.acheteur) { utilisateur, error in
            if let utilisateur = utilisateur {
                acheteur = utilisateur
            } else if let error = error {
                errorMessage = error.localizedDescription
            }
            dispatchGroup.leave()
        }
        
        // Récupérer le vendeur
        dispatchGroup.enter()
        utilisateurViewModel.getUserById(id: vente.vendeur) { utilisateur, error in
            if let utilisateur = utilisateur {
                vendeur = utilisateur
            } else if let error = error {
                errorMessage = error.localizedDescription
            }
            dispatchGroup.leave()
        }
        
        // Attendre la récupération des utilisateurs
        dispatchGroup.notify(queue: .main) {
            if let acheteur = acheteur, let vendeur = vendeur {
                // Si les deux utilisateurs sont récupérés, générer la facture
                let pdfMetaData = [
                    kCGPDFContextCreator: "Facture Service",
                    kCGPDFContextAuthor: "Votre Application"
                ]
                let format = UIGraphicsPDFRendererFormat()
                format.documentInfo = pdfMetaData as [String: Any]
                
                let pageWidth: CGFloat = 612
                let pageHeight: CGFloat = 792
                let margin: CGFloat = 50
                
                let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
                
                let data = renderer.pdfData { context in
                    context.beginPage()
                    
                    let titleFont = UIFont.boldSystemFont(ofSize: 18)
                    let textFont = UIFont.systemFont(ofSize: 12)
                    let boldFont = UIFont.boldSystemFont(ofSize: 14)
                    
                    var yPosition: CGFloat = margin
                    
                    // Titre de la facture
                    let title = "Facture"
                    title.draw(at: CGPoint(x: pageWidth / 2 - 30, y: yPosition), withAttributes: [
                        .font: titleFont
                    ])
                    yPosition += 30
                    
                    // ID de la facture et date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let dateString = dateFormatter.string(from: Date())
                    
                    let factureDetails = "Facture ID: \(vente.id)\nDate de facturation: \(dateString)"
                    factureDetails.draw(at: CGPoint(x: pageWidth - 200, y: yPosition), withAttributes: [
                        .font: textFont
                    ])
                    yPosition += 40
                    
                    // Informations de l'acheteur
                    let buyerInfo = "Acheteur: \(acheteur.nom) \(acheteur.prenom)\nAdresse: \(acheteur.adresse ?? "")\nEmail: \(acheteur.mail)"
                    buyerInfo.draw(at: CGPoint(x: margin, y: yPosition), withAttributes: [
                        .font: textFont
                    ])
                    yPosition += 60
                    
                    // Informations du vendeur
                    let sellerInfo = "Vendeur: \(vendeur.nom) \(vendeur.prenom)"
                    sellerInfo.draw(at: CGPoint(x: margin, y: yPosition), withAttributes: [
                        .font: textFont
                    ])
                    yPosition += 40
                    
                    // Liste des jeux vendus
                    let jeuxTitle = "Détails des jeux achetés"
                    jeuxTitle.draw(at: CGPoint(x: margin, y: yPosition), withAttributes: [
                        .font: boldFont
                    ])
                    yPosition += 25
                    
                    for (index, venteJeu) in jeuxVendus.enumerated() {
                        let jeuDetail = "\(index + 1). \(venteJeu.nomJeu ?? ""): \(venteJeu.quantiteVendus) x \(String(format: "%.2f", venteJeu.prixJeu!)) €"
                        jeuDetail.draw(at: CGPoint(x: margin, y: yPosition), withAttributes: [
                            .font: textFont
                        ])
                        yPosition += 20
                    }
                    
                    yPosition += 40
                    let totalText = "Montant total: \(String(format: "%.2f", vente.montantTotal)) €"
                    totalText.draw(at: CGPoint(x: margin, y: yPosition), withAttributes: [
                        .font: boldFont
                    ])
                    
                    // Note de bas de page
                    yPosition += 60
                    let footer = "Merci pour votre achat !"
                    footer.draw(at: CGPoint(x: pageWidth / 2 - 60, y: yPosition), withAttributes: [
                        .font: UIFont.italicSystemFont(ofSize: 10)
                    ])
                }
                
                completion(data, nil)
            } else {
                // Si un problème est survenu, renvoyer l'erreur
                completion(nil, NSError(domain: "FactureService", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? "Erreur inconnue"]))
            }
        }
    }
}
