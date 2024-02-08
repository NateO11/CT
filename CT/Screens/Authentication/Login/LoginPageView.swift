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
    @State private var errorSignIN: Bool = false
    @StateObject private var authState = AuthState()
    
    
    

    var body: some View {
        NavigationView {
            VStack {
                Image("CTlogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)

                Text("Login")
                    .padding(.top, 30)
                    .font(.largeTitle)
                    .bold()
                
                AuthenticationUI(innerText: "Email", variableName: $email)
                
                AuthenticationUI(innerText: "Password", variableName: $password)
                
                Button() {
                    Task {
                       await validateUser()
                     }
                   } 
            
                    label:
                {
                        Text("Login")
                            .font(.title)
                            .frame(width: 200, height: 60)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                if authState.signedIn {
                    NavigationLink(
                        "Loading...",
                        destination: MainView(),
                        isActive: $authState.signedIn
                    )
                    .navigationBarHidden(true)
                }

                NavigationLink(destination: SignUpView()) {
                    Text("New User? Sign Up Here")
                        .foregroundColor(.blue)
                        .padding()
                }

                NavigationLink(destination: PasswordResetView()) {
                    Text("Forgot Your Password? Reset Here")
                        .foregroundColor(.blue)
                }
                .padding()

                if errorSignIN {
                    Text("Password or Email is incorrect")
                        .foregroundColor(.red)
                } else {
                    Text("")
                }
            }
            .padding()
        }
        .environmentObject(authState)
        .navigationBarHidden(true)
    }

    func validateUser() async {
        await LoginFunctions.shared.validateUser(email: email, password: password, authState: authState) { success in
            errorSignIN = !success
            if success {
                authState.signedIn = true
            }
        }
    }
}

#Preview {
    LoginPageView()
}
