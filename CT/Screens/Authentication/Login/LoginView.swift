//
//  LoginView.swift
//  CT
//
//  Created by Nate Owen on 3/6/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorSignIn: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
            NavigationStack {
                    VStack {
                        
                        //  these are styles that are used across all of the auth screens
                        
                        AuthTitleAndImage(title: "Login")
                        AuthTextFieldStyle(innerText: "Email", variableName: $email)
                        AuthTextFieldStyle(innerText: "Password", variableName: $password)
                            .padding(.bottom)
                        
                        
                        Button{
                            Task{
                                try await                         viewModel.signIn(withEmail: email, password: password)
                            }
                        } label: {
                            HStack{
                                AuthButtonStyle(buttonText: "Login")
                            }
                        }
                        
                      
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
                            Alert(title: Text("Try Again"), message: Text("Email or Username has already been used. Make sure all fields are filled in"),
                                  dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding()
                    
                }
                
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }

#Preview {
    LoginView()
}
