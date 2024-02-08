//
//  Password Reset Functions.swift
//  CT
//
//  Created by Nate Owen on 2/8/24.
//


import Firebase
import FirebaseFirestore

class PasswordResetFunctions {
    static let shared = PasswordResetFunctions()
    
    func checkIfEmailExists(emailToCheck: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()

        // Query the 'Users' collection
        db.collection("Users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying Firestore: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Check each document in the collection
            for document in querySnapshot?.documents ?? [] {
                if let userEmail = (document.data()["UserEmail"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   userEmail.caseInsensitiveCompare(emailToCheck.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame {
                    // The given email matches one in the database
                    completion(true)
                    return
                }
            }

            // No match found
            completion(false)
        }
    }

    func resetPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        checkIfEmailExists(emailToCheck: email) { exists in
            if exists {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        let errorMessage = "Error resetting password: \(error.localizedDescription)"
                        print(errorMessage)
                        completion(false, errorMessage)
                    } else {
                        print("Password reset email sent successfully.")
                        completion(true, nil)
                    }
                }
            } else {
                let errorMessage = "That email is not connected to an account"
                print(errorMessage)
                completion(false, errorMessage)
            }
        }
    }
    
}

