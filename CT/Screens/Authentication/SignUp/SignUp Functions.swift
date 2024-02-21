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
    
    func addPositionToUser(userID: String, position: String) {
        let db = Firestore.firestore()
        print (userID)
        let userRef = db.collection("Users").document(userID)
        
        
        // Use updateData to add or update the "Position" field
        userRef.updateData(["Position": position]) { error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
            } else {
                print("Position added or updated successfully")
            }
            
        }
    }
    
    func addSchoolToUser(userID: String, school: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userID)
        
        // Use updateData to add or update the "Position" field
        userRef.updateData(["School": school]) { error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
            } else {
                print("Position added or updated successfully")
            }
            
        }
    }

}
