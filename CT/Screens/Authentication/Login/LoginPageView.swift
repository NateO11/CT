//
//  LoginPageView.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//

import SwiftUI


struct LoginPageView: View {
    
    
    /*
     Below are specific private variables that are handled during all login attempts
     
     
     email,password, ID are all strings
     errorSignIN is a boolean value that is set to true during issues
     signing in. Otherwise it is left as false
     
     
     AuthState updates our function called AuthState which tracks the status of the signedIN variable
     
     
     */
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var ID: String = ""
    @State private var errorSignIn: Bool = false
    @StateObject private var authState = AuthState()
    @State private var navigateToMainView = false
    
    
    

    var body: some View {
        
        NavigationView {
            
            VStack {
                
              //  these are styles that are used across all of the auth screens
            
                AuthTitleAndImage(title: "Login")
                AuthTextFieldStyle(innerText: "Email", variableName: $email)
                AuthTextFieldStyle(innerText: "Password", variableName: $password)
                    .padding(.bottom)
                
                Button() {
                    Task {
                       await validateUser()
                     }
                   } 
             
            
                    label:
                {
                    AuthButtonStyle(buttonText: "Login")
                }

                
                // now the validate user function which is executed in the Login Funcitons file and will update the signedIn AuthState var
                NavigationLink(destination: MainView(), isActive: $navigateToMainView) { EmptyView() }
                    .navigationBarHidden(true)

                
                // these are our linked to the other Auth Screens
                
                NavigationLink(destination: SignUpView()) {
                    Text("New User? Sign Up Here")
                        .foregroundColor(.blue)
                        .padding()
                }

                NavigationLink(destination: PasswordResetView()) {
                    Text("Forgot Your Password? Reset Here")
                        .foregroundColor(.blue)
                }

                // alert error pops up wehn error signin is true
                
                .alert(isPresented: $errorSignIn) {
                    Alert(title: Text("Oopsie"), message: Text("Email or Username has already been used. Make sure all fields are filled in.😜🤪"),
                          dismissButton: .default(Text("OK")))
                            }
            }
            .padding()
        }
        
       // You are injecting an instance of authState
       // By doing this, any child views of the current view can access and observe changes to the properties of authState
        
        .environmentObject(authState)
        .navigationBarHidden(true)
    }

    func validateUser() async {
        await LoginFunctions.shared.validateUser(email: email, password: password, authState: authState) { success in
            errorSignIn = !success
            if success {
                authState.signedIn = true
                DispatchQueue.main.async {
                    self.navigateToMainView = true 
                }
            }
        }
    }
}

#Preview {
    LoginPageView()
}
