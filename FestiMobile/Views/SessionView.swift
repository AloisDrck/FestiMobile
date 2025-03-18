//
//  SessionView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 18/03/2025.
//

import SwiftUI

struct SessionView: View {
    @StateObject private var sessionVModel = SessionViewModel()
    
    var body: some View {
        ZStack {
            VStack{
                List {
                    ForEach(sessionVModel.sessions) { session in
                        VStack(alignment: .leading) {
                            Text("Session du \(formattedDate(session.dateDebut)) au \(formattedDate(session.dateFin))")
                                .font(.headline)
                            Text("Statut: \(session.statutSession)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: sessionVModel.deleteSession)
                    .navigationTitle("Liste des Sessions")
                }
                .onAppear {
                    sessionVModel.fetchSessions()
                }
            }
            .navigationTitle("Liste des Sessions")
        }
        .navigationTitle("Sessions")
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
