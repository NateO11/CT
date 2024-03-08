//
//  SignUpView.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var username: String = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                                        
                    AuthTitleAndImage(title: "Sign Up ")
                    AuthTextFieldStyle(innerText: "Full Name", variableName: $fullName)
                    AuthTextFieldStyle(innerText: "Email", variableName: $email)
                    AuthTextFieldStyle(innerText: "Password", variableName: $password)
                    AuthTextFieldStyle(innerText: "Confirm Password", variableName: $confirmPassword)
                        .padding(.bottom)
                    
                   Button {
                    Task {
                        try await viewModel.signUp(email:email,password:password, fullname: fullName)
                        }
                    } label: {
                        AuthButtonStyle(buttonText: "Log in")
                    }
                    
                    NavigationLink{
                        LoginPageView()
                            .navigationBarBackButtonHidden(true)
                        }
                        label: {
                            Text("go to login bitch")
                        }
                }
            }
        }
    }
}



#Preview {
    SignUpView()
}
