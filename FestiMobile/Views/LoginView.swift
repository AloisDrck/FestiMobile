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
    @State private var navigateToSessions: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("gestionnaireBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) { // Espacement entre les boutons
                    Button("Acheter") {
                        navigateToBuyer = true
                    }
                    .buttonStyle(LargeButtonStyle())
                    .navigationDestination(isPresented: $navigateToBuyer) {
                        ListUserView(isAcheteur: true)
                    }

                    Button("Déposer") {
                        navigateToSeller = true
                    }
                    .buttonStyle(LargeButtonStyle())
                    .navigationDestination(isPresented: $navigateToSeller) {
                        ListUserView(isAcheteur: false)
                    }

                    // --------------------------------------------------------------
                    // QUE POUR LES ADMINS
                    
                    Button("Ajouter un utilisateur") {
                        navigateToAddUser = true
                    }
                    .buttonStyle(LargeButtonStyle())
                    .navigationDestination(isPresented: $navigateToAddUser) {
                        AddUserView()
                    }
                    Button("Sessions") {
                        navigateToSessions = true
                    }
                    .buttonStyle(SessionsButtonStyle())
                    .navigationDestination(isPresented: $navigateToSessions) {
                        SessionView()
                    }
                    
                    // --------------------------------------------------------------
                    
                }
                .padding(.horizontal, 40)
            }
        }
        .navigationTitle("Gestionnaire")
    }
}

struct LargeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.horizontal, 20) // Marge horizontale pour que les boutons soient bien espacés
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Effet de clic
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SessionsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 75)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Effet de clic
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
