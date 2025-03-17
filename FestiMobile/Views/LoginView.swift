//
//  LoginView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var navigateToBuyer: Bool = false
    @State private var navigateToSeller: Bool = false
    @State private var navigateToAddUser: Bool = false
    
    var body: some View {
        NavigationView {
            HStack {
                Button("Acheter") {
                    navigateToBuyer = true
                }
                .fontWeight(.bold)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .navigationDestination(isPresented: $navigateToBuyer) {
                    BuyerView()  // Utilisation de la fermeture qui retourne BuyerView
                }
                
                Button("Déposer") {
                    navigateToSeller = true
                }
                .fontWeight(.bold)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .navigationDestination(isPresented: $navigateToSeller) {
                    SellerView()  // Utilisation de la fermeture qui retourne SellerView
                }
                Button("Ajouter un utilisateur") {
                    navigateToAddUser = true
                }
                .fontWeight(.bold)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .navigationDestination(isPresented: $navigateToAddUser) {
                    AddUserView()
                }
            }
        }
        .navigationTitle("Page Gestionnaire")
    }
}
