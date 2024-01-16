//
//  UserManager.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//
// UserManager.swift

import Firebase
import FirebaseFirestore

class UserManager {
    static let shared = UserManager()

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


    func createUserInfo(name: String, email: String, username: String, password: String, authState: AuthState) {
        let db = Firestore.firestore()
        _ = Auth.auth().currentUser?.email ?? ""
        let userID = Auth.auth().currentUser?.uid

        let userRef = db.collection("Users").document(userID!)

        userRef.setData(["Name": name, "UserEmail": email, "Username": username, "Password": password, "UserID": userID!]) { error in
            if error != nil {
                print("Error updating document")
            } else {
                print("Document successfully written or updated.")
                // Update the AuthState to indicate the user is signed in
                authState.signedIn = true
            }
        }
    }

    func getID(forEmail email: String, completion: @escaping (String?) -> Void) async {
        let db = Firestore.firestore()

        do {
            let querySnapshot = try await db.collection("Users").getDocuments()

            for document in querySnapshot.documents {
                if let userEmail = (document.data()["UserEmail"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   userEmail.caseInsensitiveCompare(email.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame {
                    let documentID = document.documentID
                    print("ID found: \(documentID)")
                    completion(documentID)
                    return
                }
            }

            // If no match is found
            print("No document found with the specified email.")
            print("Email to search: \(email)")
            completion(nil)
        } catch {
            print("Error getting documents: \(error)")
            completion(nil)
        }
    }


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
