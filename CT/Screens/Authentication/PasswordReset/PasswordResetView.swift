//
//  PasswordResetView.swift
//  CT
//
//  Created by Nate Owen on 1/3/24.
//

import SwiftUI
import Firebase

struct PasswordResetView: View {
    @State private var email: String = ""
    @State private var resetSuccessMessage: Bool?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                Image("CTlogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)

                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                TextField("Enter Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                Button(action: { resetPassword() }) {
                    Text("Reset")
                        .font(.title)
                        .frame(width: 200, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)

                NavigationLink(destination: LoginPageView()) {
                    Text("Have an Account? Login Here")
                        .foregroundColor(.blue)
                        .padding()
                }

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if resetSuccessMessage != nil {
                    Text("Check your inbox for a Reset Password Email")
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }

    func resetPassword() {
        PasswordResetFunctions.shared.resetPassword(email: email) { success, message in
            if success {
                resetSuccessMessage = true
            } else {
                errorMessage = message ?? "An unknown error occurred."
            }
        }
    }

}

#Preview {
    PasswordResetView()
}
