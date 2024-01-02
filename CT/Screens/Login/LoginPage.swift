//
//  LoginPage.swift
//  CT
//
//  Created by Nate Owen on 12/10/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class AuthState: ObservableObject {
    @Published var signedIn: Bool = false
}

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var ID: String = ""

    @State private var errorSignIN: Bool = false

    @StateObject private var authState = AuthState()

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()

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

                Button() {
                    Task {
                        await validateUser()
                    }
                } label: {
                    Text("Login")
                        .font(.title)
                        .frame(width: 200, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }


                if authState.signedIn {
                    NavigationLink(" "
                                   , destination: ExploreView(viewModel: ExploreViewModel()),
                        isActive: $authState.signedIn
                       
                    )
                    .navigationBarHidden(true)
                }

                NavigationLink(destination: SignUp()) {
                    Text("New User? Sign Up Here")
                        .foregroundColor(.blue)
                        .padding()
                }

                NavigationLink(destination: passwordReset()) {
                    Text("Forgot Your Password? Reset Here")
                        .foregroundColor(.blue)
                }
                .padding()
                if errorSignIN {
                    Text("Password or Email is incorrect")
                        .foregroundColor(.red)
                }
                else{
                    Text(" ")
                }
                
            }
            .padding()
        }
        .environmentObject(authState)
        .navigationBarHidden(true)
    }

    func validateUser() async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            // Successfully signed in
            await getID(forEmail: email)
            authState.signedIn = true
            errorSignIN = false
        } catch {
            // Error signing in
            authState.signedIn = false
            errorSignIN = true
            print("Error signing in:", error.localizedDescription)
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
    LoginPage()
}
