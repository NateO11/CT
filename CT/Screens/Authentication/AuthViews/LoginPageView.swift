//
//  LoginPageView.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//

import SwiftUI


struct LoginPageView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                
                    AuthTitleAndImage(title: "Login")
                    AuthTextFieldStyle(innerText: "Email", variableName: $email)
                    AuthTextFieldStyle(innerText: "Password", variableName: $password)
                        .padding(.bottom)
                
                    // button for login using protocol
                    Button {
                        Task {
                            try await viewModel.signIn(email:email,password:password)
                        }
                    } label: {
                        AuthButtonStyle(buttonText: "Log in")
                        }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0:0.5)
                    
                    
                    // redirect to sign up
                    NavigationLink{
                        SignUpView()
                            .navigationBarBackButtonHidden(true)
                        }
                        label: {
                            HStack{
                                Text("Don't have an account?")
                                    .padding(.vertical)
                                Text("Click Here")
                                    .bold()
                        }
                            
                    }
                }
            }
        }
    }
}

extension LoginPageView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginPageView()
}
