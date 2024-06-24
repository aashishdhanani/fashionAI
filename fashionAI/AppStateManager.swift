import SwiftUI
import Firebase

class AppStateManager: ObservableObject {
    @Published var userIsLoggedIn: Bool = false
    
    init() {
        setupFirebaseAuthListener()
    }
    
    func setupFirebaseAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.userIsLoggedIn = user != nil
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            userIsLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
