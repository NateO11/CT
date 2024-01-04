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

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)

                TextField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)

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
                        destination: ExploreView(viewModel: ExploreViewModel(),ID: ID),
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
        await UserManager.shared.validateUser(email: email, password: password, authState: authState) { success in
            errorSignIN = !success
        }
    }
}

#Preview {
    LoginPageView()
}
