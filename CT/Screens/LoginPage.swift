//
//  LoginPage.swift
//  CT
//
//  Created by Nate Owen on 12/10/23.
//

import SwiftUI
import Firebase

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var signedIn: Bool = false
    @State private var login: Bool = false

    var body: some View {
        // NavigationView moved to the top
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Image("CTlogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 30)

                TextField("Email", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)

                TextField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .padding()
                    .shadow(radius: 10)

                Button(action: { validateUser() }) {
                    Text("Login")
                        .font(.title)
                        .frame(width: 200, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                // NavigationLink at the bottom
                NavigationLink(destination: SignUp()) {
                    Text("New User? Sign Up Here")
                        .foregroundColor(.blue)
                        .padding()
                }
                .padding()
            }
            .padding()
        }
        .navigationBarHidden(true)

    }
    

    func validateUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // At this point, our user is signed in
            signedIn = true
        }
    }
}

#Preview {
    LoginPage()
}
