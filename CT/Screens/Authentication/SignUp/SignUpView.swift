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

    // Inject the AuthState object
    @StateObject private var authState = AuthState()

    var body: some View {
        NavigationView {
            VStack {
                Image("CTlogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)

                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                TextField("First Name", text: $name)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                TextField("Username", text: $username)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                TextField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                TextField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))
                    .padding(.bottom, 20)

                Button(action: {
                    SignUpFunctions.shared.createUser(name: name, email: email, password: password, username: username, confirmPassword: confirmPassword, authState: authState) { success in
                        errorLogin = !success
                    }
                })
                {
                    AuthButtonStyle(buttonText: "Sign Up")
                }
                
                
                .padding(.top, 20)

                NavigationLink(destination: LoginPageView()) {
                    Text("Already have an account? Log in here.")
                        .foregroundColor(.blue)
                        .padding()
                }

                if errorLogin {
                    Text("Email or Username has already been used")
                        .foregroundColor(.red)
                        .padding(.top)
                    Text("Make sure all fields are filled in")
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
            }
            .padding()
            .environmentObject(authState)
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    SignUpView()
}
