//
//  SessionViewModel.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//


import Foundation
import Combine

class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = [] // Liste des sessions
    @Published var countdownText: String = ""
    @Published var message: String = ""
    @Published var isSessionActive: Bool = false
    
    private var sessionService = SessionService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchSessions()
        observeSessionStatus()
        sessionService.fetchSessionStatus() // Lancer la récupération initiale
    }
    
    func fetchSessions() {
        sessionService.fetchAllSessions()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Erreur lors de la récupération des sessions:", error)
                }
            }, receiveValue: { [weak self] sessions in
                self?.sessions = sessions
            })
            .store(in: &cancellables)
    }
    
    func deleteSession(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let sessionId = sessions[index].id ?? ""
        
        sessionService.deleteSession(id: sessionId) { success in
            if success {
                self.sessions.remove(at: index)
            }
        }
    }
    
    func addSession(_ session: Session, completion: @escaping (Bool, String?) -> Void) {
        sessionService.addSession(session) { success, errorMessage in
            if success {
                self.fetchSessions()
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
    
    private func observeSessionStatus() {
        sessionService.$isActive
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                self?.isSessionActive = isActive
                self?.handleSessionChange()
            }
            .store(in: &cancellables)

        sessionService.$session
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                guard let session = session else { return }
                if self?.isSessionActive == true {
                    self?.startCountdown(to: session.dateFin, message: "Une session est en cours et finira dans")
                } else {
                    self?.startCountdown(to: session.dateDebut, message: "La prochaine session commencera dans")
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleSessionChange() {
        if isSessionActive {
            sessionService.fetchSessionDetails()
        } else {
            sessionService.fetchSessionDetails()
        }
    }

    private func startCountdown(to targetDate: Date?, message: String) {
        guard let targetDate = targetDate else { return }
        self.message = message
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let remainingTime = targetDate.timeIntervalSinceNow
            
            if remainingTime <= 0 {
                self.countdownText = "\(message) est terminée."
                self.sessionService.fetchSessionStatus() // Recharger les données
            } else {
                let days = Int(remainingTime) / (24 * 3600)
                let hours = (Int(remainingTime) % (24 * 3600)) / 3600
                let minutes = (Int(remainingTime) % 3600) / 60
                let seconds = Int(remainingTime) % 60
                self.countdownText = "\(days)j \(hours)h \(minutes)m \(seconds)s"
            }
        }
    }
    
    func fetchSessionStatus() {
        sessionService.fetchSessionStatus()
    }
}
