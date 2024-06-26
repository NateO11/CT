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
    @State private var errorMessage: String = ""
    @State private var errorMessageBool: Bool = false
    @State private var confirmPassword: String = ""
    @State private var username: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @FocusState var isInputActive: Bool
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    
                    AuthTitleAndImage(title: "Sign Up ")
                    AuthTextFieldStyle(innerText: "Full Name", variableName: $fullName)
                        .keyboardType(.asciiCapable)
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
                    AuthTextFieldStyle(innerText: "Email", variableName: $email)
                        .keyboardType(.emailAddress)
                        .focused($isInputActive)
                        .autocorrectionDisabled(true)
                    AuthTextFieldStyle(innerText: "Password", variableName: $password)
                        .keyboardType(.asciiCapable)
                        .focused($isInputActive)
                        .autocorrectionDisabled(true)
                    AuthTextFieldStyle(innerText: "Confirm Password", variableName: $confirmPassword)
                        .keyboardType(.asciiCapable)
                        .focused($isInputActive)
                        .autocorrectionDisabled(true)
                        .padding(.bottom)
                    
                    Button {
                        Task {
                            errorMessage = try await viewModel.signUp(email:email,password:password, fullname: fullName)
                            if !errorMessage.isEmpty {
                                errorMessageBool = true
                            }
                        }
                    } label: {
                        AuthButtonStyle(buttonText: "Sign Up")
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0:0.5)
                    .alert(errorMessage,isPresented: $errorMessageBool){
                        Button("OK") {}
                    }
                    
                    
                    NavigationLink{
                        LoginPageView()
                            .navigationBarBackButtonHidden(true)
                    }
                label: {
                    HStack{
                        Text("Already have an account?")
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


extension SignUpView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
}



#Preview {
    SignUpView()
}
