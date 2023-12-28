//
//  LoginPage.swift
//  CT
//
//  Created by Nate Owen on 12/10/23.
//

import SwiftUI
import Firebase

class AuthState: ObservableObject {
    @Published var signedIn: Bool = false
}

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
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

                Button(action: { validateUser() }) {
                    Text("Login")
                        .font(.title)
                        .frame(width: 200, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                if authState.signedIn {
                    NavigationLink("Go to Second View",
                        destination: ContentView(),
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

    func validateUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                authState.signedIn = true
                errorSignIN = false

            } else {
                authState.signedIn = false
                errorSignIN = true
                print("Error signing in:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}


#Preview {
    LoginPage()
}
