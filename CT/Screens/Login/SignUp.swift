//
//  SignUp.swift
//  CT
//
//  Created by Nate Owen on 12/14/23.
//

import SwiftUI
import Firebase

struct SignUp: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var ID: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorLogin: Bool = false
    

    // Inject the AuthState object
    @StateObject private var authState = AuthState()


    var body: some View {
        NavigationView {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Image("CTlogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    
                
                TextField("First Name", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)

                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)

                TextField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)

                TextField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .shadow(radius: 10)
                    .padding()

                Button(action: {
                    createUser()
                }) {
                    Text("Sign Up")
                        .font(.title)
                        .frame(width: 200, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                // Conditional NavigationLink based on AuthState
                NavigationLink(
                    destination: ProfilePage(),
                    isActive: $authState.signedIn,
                    label: { EmptyView()}
                   
                )
                .navigationBarHidden(true)

                
                
                NavigationLink(destination: LoginPage()) {
                    Text("Existing User? Sign In Here")
                        .foregroundColor(.blue)
                        .padding()
                }

                
                
                if errorLogin{
                    Text("Email or Username has already been used")
                        .foregroundColor(.red)
                        .padding()
                }
               
            }
        }
        .environmentObject(authState)
        .navigationBarHidden(true)
    }

    func createUser() {
        Task {
            if name != "" && email != "" && password != "" && username != "" && confirmPassword != "" {
                if confirmPassword == password {
                    do {
                        try await Auth.auth().createUser(withEmail: email, password: password)
                        errorLogin = false
                        createUserInfo()
                        await getID(forEmail: email)
                    } catch {
                        errorLogin = true
                        print("Error creating user:", error.localizedDescription)
                    }
                } else {
                    errorLogin = true
                }
            } else {
                errorLogin = true
            }
        }
    }

    

    func createUserInfo() {
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let userID = Auth.auth().currentUser?.uid

        let userRef = db.collection("Users").document(userID!)

        userRef.setData(["Name": userEmail, "UserEmail": userEmail, "Username": username, "Password": password, "UserID": userID!]) { error in
            if error != nil {
                print("Error updating document")
            } else {
                print("Document successfully written or updated.")

                // Update the AuthState to indicate the user is signed in
                authState.signedIn = true
            }
        }
    }
    
    func getID(forEmail email: String) async {
        let db = Firestore.firestore()

        do {
            let querySnapshot = try await db.collection("Users").getDocuments()

            for document in querySnapshot.documents {
                if let userEmail = (document.data()["UserEmail"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   userEmail.caseInsensitiveCompare(email.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame {
                    let documentID = document.documentID
                    print("ID found: \(documentID)")
                    // Save the document ID to the variable ID
                    self.ID = documentID

                    return // Break the loop once a match is found
                }
            }

            // If no match is found
            print("No document found with the specified email.")
            print("Email to search: \(email)")
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
}

#Preview {
    SignUp()
}
