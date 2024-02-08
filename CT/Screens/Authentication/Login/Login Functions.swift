//
//  Login Functions.swift
//  CT
//
//  Created by Nate Owen on 2/8/24.
//

import Firebase
import FirebaseFirestore



class LoginFunctions {
    static let shared = LoginFunctions()
    
    func validateUser(email: String, password: String, authState: AuthState, completion: @escaping (Bool) -> Void) async {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Successfully signed in
            authState.currentUserEmail = email
            authState.currentUserId = authResult.user.uid // Set the user ID
            authState.signedIn = true
            
            completion(true)
        } catch {
            // Error signing in
            authState.signedIn = false
            completion(false)
            print("Error signing in:", error.localizedDescription)
        }
    }
}
