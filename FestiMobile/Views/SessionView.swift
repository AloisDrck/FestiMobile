//
//  SessionView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 18/03/2025.
//

import SwiftUI

struct SessionView: View {
    @StateObject private var sessionVModel = SessionViewModel()
    @State private var navigateToAddSessionView = false
    
    var body: some View {
        VStack {
            
            List {
                ForEach(sessionVModel.sessions) { session in
                    VStack(alignment: .leading) {
                        Text("Session du \(formattedDate(session.dateDebut)) au \(formattedDate(session.dateFin))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.bottom, 2)
                        
                        Text("Statut: \(session.statutSession)")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 10)
                    }
                    .padding()
                    .padding(.horizontal)
                }
                .onDelete(perform: sessionVModel.deleteSession)
                .navigationTitle("Liste des Sessions")
            }
            .cornerRadius(15)
            .shadow(radius: 5)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .onAppear {
                sessionVModel.fetchSessions()
            }
            
            Button(action: {
                navigateToAddSessionView = true
            }) {
                Text("Nouvelle session")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
            .sheet(isPresented: $navigateToAddSessionView) {
                AddSessionView(viewModel: sessionVModel)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Sessions")
        .background(
            Image("generalBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}
