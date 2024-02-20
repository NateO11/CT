//
//  SignUpView.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorLogin: Bool = false
    @State private var showAlert: Bool = false

    // Inject the AuthState object
    @StateObject private var authState = AuthState()

    var body: some View {
        NavigationView {
            VStack {
                AuthTitleAndImage(title: "Sign Up")

                AuthTextFieldStyle(innerText: "Name", variableName: $name)
                AuthTextFieldStyle(innerText: "Username", variableName: $username)
                AuthTextFieldStyle(innerText: "Email", variableName: $email)
                AuthTextFieldStyle(innerText: "Password", variableName: $password)
                AuthTextFieldStyle(innerText: "Confirm Password", variableName: $confirmPassword)

                Button(action: {
                    SignUpFunctions.shared.createUser(name: name, email: email, password: password, username: username, confirmPassword: confirmPassword, authState: authState) { success in
                        errorLogin = !success
                        
        
                        
                    }
                })
                {
                    AuthButtonStyle(buttonText: "Sign Up")
                }
                .padding(.top, 20)
                
                if authState.signedIn {
                    NavigationLink("Creating Your Account", destination: MainView())
                        .navigationBarHidden(true)
                }

                NavigationLink(destination: LoginPageView()) {
                    Text("Already have an account? Log in here.")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                // basic alert when errorLogin is true

                .alert(isPresented: $errorLogin) {
                    Alert(title: Text("Oopsie"), message: Text("Email or Username has already been used. Make sure all fields are filled in.😜🤪"),
                          dismissButton: .default(Text("OK")))
                            }
            }
            
            // You are injecting an instance of authState
            // By doing this, any child views of the current view can access and observe changes to the properties of authState
            
            .padding()
            .environmentObject(authState)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}




#Preview {
    SignUpView()
}
