//
//  SessionViewModel.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//


import Foundation
import Combine

class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var countdownText: String = ""
    @Published var message: String = ""
    @Published var isSessionActive: Bool = false
    @Published var session: Session?
    
    private var sessionService = SessionService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchSessions()
        observeSessionStatus()
        sessionService.fetchSessionStatus()
    }
    
    // Récupérer toutes les sessions disponibles.
    // Entrées :
    // - Aucun argument.
    // - Retourne directement la liste des sessions dans `sessions` via un abonnement à un publisher.
    //
    // Sorties :
    // - Succès : La liste des sessions est mise à jour avec les sessions récupérées.
    // - Échec : En cas d'erreur, un message d'erreur est imprimé dans la console.

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
    
    // Supprimer une session de la liste par son index.
    // Entrées :
    // - indexSet (IndexSet) : L'index de la session à supprimer dans la liste `sessions`.
    // - Aucun retour explicite, la suppression se fait directement dans la méthode.
    //
    // Sorties :
    // - Succès : La session est supprimée de la liste `sessions` si l'opération de suppression est réussie.
    // - Échec : Aucun retour explicite, mais la session ne sera pas supprimée si l'opération échoue.

    func deleteSession(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let sessionId = sessions[index].id ?? ""
        
        sessionService.deleteSession(id: sessionId) { success in
            if success {
                self.sessions.remove(at: index)
            }
        }
    }
    
    // Ajouter une nouvelle session à la liste des sessions.
    // Entrées :
    // - session (Session) : L'objet `Session` à ajouter.
    // - completion (Bool, String?) : Closure renvoyée avec le résultat de l'ajout (succès ou échec) et un message d'erreur le cas échéant.
    //
    // Sorties :
    // - Succès : La liste des sessions est mise à jour et la nouvelle session est récupérée.
    // - Échec : Un message d'erreur est retourné dans le paramètre `completion`.

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
    
    // Observer l'état de la session active et la mise à jour de la session en cours.
    // Entrées :
    // - Aucun argument.
    // - Aucun retour explicite, les abonnements sont gérés dans la méthode.
    //
    // Sorties :
    // - Succès : Si la session devient active, la méthode `fetchSessionDetails()` est appelée pour récupérer les détails de la session.
    // - Échec : Aucun retour explicite en cas d'échec, mais la session est mise à jour en fonction du statut actif.

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
    
    // Gérer les changements dans l'état de la session (active ou non).
    // Entrées :
    // - Aucun argument.
    // - Aucun retour explicite, la méthode effectue des appels de service pour récupérer les détails de la session.
    //
    // Sorties :
    // - Succès : Si la session est active, les détails de la session sont récupérés.
    // - Échec : Aucun retour explicite, mais les détails de la session sont chargés selon l'état de la session.

    private func handleSessionChange() {
        if isSessionActive {
            sessionService.fetchSessionDetails()
        } else {
            sessionService.fetchSessionDetails()
        }
    }

    // Démarrer un compte à rebours jusqu'à une date cible pour afficher le temps restant avant la fin de la session.
    // Entrées :
    // - targetDate (Date?) : La date cible jusqu'à laquelle le compte à rebours doit être effectué.
    // - message (String) : Le message à afficher pendant le compte à rebours (avant ou après la session).
    //
    // Sorties :
    // - Succès : Le compte à rebours est lancé, avec une mise à jour régulière de `countdownText`
    // - Échec : Si la date cible est invalide, aucune action n'est effectuée.

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
    
    // Récupérer le statut de la session en cours (active ou non).
    // Entrées :
    // - Aucun argument.
    // - Retourne directement le statut de la session dans la méthode via un appel au service.
    //
    // Sorties :
    // - Succès : Le statut de la session active est mis à jour.
    // - Échec : Aucun retour explicite en cas d'échec, mais les données sont rechargées.

    func fetchSessionStatus() {
        sessionService.fetchSessionStatus()
    }
    
    // Récupérer les détails de la session en cours.
    // Entrées :
    // - Aucun argument.
    // - Les détails de la session en cours sont mis à jour et affichés dans la vue.
    //
    // Sorties :
    // - Succès : Si une session "En Cours" est trouvée, elle est affichée et la liste `sessions` est mise à jour.
    // - Échec : Aucun retour explicite en cas d'échec, mais la session en cours est filtrée.

    func fetchSessionEnCours() {
        sessionService.fetchSessionDetails()
        sessionService.$session
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                if let session = session, session.statutSession == "En Cours" {
                    self?.session = session
                    self?.sessions = [session]
                    self?.message = "Une session est en cours"
                }
            }
            .store(in: &cancellables)
    }
    
    // Récupérer les détails d'une session spécifique par son ID.
    // Entrées :
    // - id (String) : L'ID de la session à récupérer.
    // - Aucun retour explicite, les détails de la session sont directement mis à jour.
    //
    // Sorties :
    // - Succès : Les détails de la session avec l'ID spécifié sont récupérés et stockés dans `session`.
    // - Échec : Aucun retour explicite en cas d'échec, mais les détails de la session ne seront pas mis à jour.

    func fetchSessionById(id: String) {
        sessionService.fetchSessionById(id: id) { [weak self] session in
            DispatchQueue.main.async {
                self?.session = session
            }
        }
    }
}
