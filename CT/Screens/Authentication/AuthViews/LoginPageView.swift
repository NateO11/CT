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
    @State private var validLoginMessage: String = ""
    @State private var validLoginMessageBool: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @FocusState var isInputActive: Bool
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                
                    AuthTitleAndImage(title: "Login")
                    AuthTextFieldStyle(innerText: "Email", variableName: $email)
                        .keyboardType(.emailAddress)
                        .focused($isInputActive)
                        .autocorrectionDisabled(true)
                        
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isInputActive = false
                                }
                            }
                        }
                    AuthTextFieldStyle(innerText: "Password", variableName: $password)
                        .keyboardType(.asciiCapable)
                        .focused($isInputActive)
                        .autocorrectionDisabled(true)
                        
                        
                        .padding(.bottom)
                
                    // button for login using protocol
                    Button {
                        Task {
                            validLoginMessage = try await viewModel.signIn(email:email,password:password)
                            if !validLoginMessage.isEmpty {
                                validLoginMessageBool = true
                            }
                        }
                    } label: {
                        AuthButtonStyle(buttonText: "Log in")
                        }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0:0.5)
                    .alert("Invalid Username or Password",isPresented: $validLoginMessageBool){
                        Button("OK") {}
                    }
                    
                    
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
