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
                    .padding(.bottom, 30)

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
                    destination: LoginPage(),
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
        if email != "" && password != "" && username != "" && confirmPassword != "" {
            if confirmPassword == password {
                    Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
                        if err != nil {
                            errorLogin = true
                            print("\(String(describing: err))")
                            return
                        } else {
                            errorLogin = false
                            createUserInfo()
                        }
                    
                }
            }
            errorLogin = true
        }
        errorLogin = true
    }
    

    func createUserInfo() {
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let userID = Auth.auth().currentUser?.uid

        let userRef = db.collection("Users").document(userID!)

        userRef.setData(["UserEmail": userEmail, "Username": username, "Password": password, "UserID": userID!]) { error in
            if error != nil {
                print("Error updating document")
            } else {
                print("Document successfully written or updated.")

                // Update the AuthState to indicate the user is signed in
                authState.signedIn = true
            }
        }
    }
}

#Preview {
    SignUp()
}
