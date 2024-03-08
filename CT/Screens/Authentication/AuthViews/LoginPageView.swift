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
                    
                    Button {
                        Task {
                            try await viewModel.signIn(email:email,password:password)
                        }
                    } label: {
                        AuthButtonStyle(buttonText: "Log in")
                        }
                    NavigationLink{
                        SignUpView()
                            .navigationBarBackButtonHidden(true)
                        }
                        label: {
                            Text("go to sign up bitch")
                        }
                    }
                }
            }
        }
    }



#Preview {
    LoginPageView()
}
