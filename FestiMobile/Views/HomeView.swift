//
//  HomeView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var navigateToLogin: Bool = false
    @State private var navigateToMainApp: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("backgroundImage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Spacer().frame(height: 100) // Pour que ça fasse jolk avec le background sinon cetait trop haut
                    
                    if !viewModel.message.isEmpty {
                        Text(viewModel.message)
                            .font(.headline)
                            .padding(.top, 10)
                    } else {
                        Text("Ya pas de message dans le ViewModel")
                            .font(.headline)
                            .padding(.top, 10)
                    }
                    
                    if !viewModel.countdownText.isEmpty {
                        Text(viewModel.countdownText)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding()
                    } else {
                        Text("Ya pas de countdown dans le ViewModel")
                            .font(.headline)
                            .padding(.top, 10)
                    }
                    
                    if viewModel.isSessionActive {
                        Button("Voir les jeux") {
                            navigateToMainApp = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .navigationDestination(isPresented: $navigateToMainApp) {
                            MainAppView()
                        }
                    }
                    
                    Button("Connexion") {
                        navigateToLogin = true
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .navigationDestination(isPresented: $navigateToLogin) {
                        LoginView() // Navigation vers LoginView quand navigateToLogin est true
                    }
                }
                .padding()
                .onAppear {
                    viewModel.fetchSessionStatus() // Assurez-vous que les données sont chargées au début
                }
            }
        }
    }
}
