//
//  AuthViewModel.swift
//  CT
//
//  Created by Nate Owen on 3/6/24.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
                // Perform the sign-in operation
                try await Auth.auth().signIn(withEmail: email, password: password)

                // Update your user session or perform any other necessary actions
                // For example, you might want to fetch the user after successful sign-in
                try await fetchUser()
            } catch {
                // Handle errors here
                print("Error signing in: \(error.localizedDescription)")
                // You can set errorSignIn to true to trigger the alert
               // errorSignIn = true
            }

    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        print("create user")
    }
    
    func signOut(){
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        
    }
    
    
    
}
