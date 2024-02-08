//
//  SignUp Functions.swift
//  CT
//
//  Created by Nate Owen on 2/8/24.
//


import Firebase
import FirebaseFirestore

class SignUpFunctions {
    static let shared = SignUpFunctions()
    
    
    func createUser(name: String, email: String, password: String, username: String, confirmPassword: String, authState: AuthState, completion: @escaping (Bool) -> Void) {
        Task {
            if name != "" && email != "" && password != "" && username != "" && confirmPassword != "" {
                if confirmPassword == password {
                    do {
                        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                        authState.currentUserEmail = email
                        authState.currentUserId = authResult.user.uid // Set the user ID
                        authState.signedIn = true
                        
                        completion(true)
                    } catch {
                        completion(false)
                        print("Error creating user:", error.localizedDescription)
                    }
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}
