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
    @State private var resetSuccess: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                AuthTitleAndImage(title: "Reset Password")


                AuthTextFieldStyle(innerText: "Enter Email", variableName: $email)

                Button(action: { resetPassword() }) {
                    AuthButtonStyle(buttonText: "Reset")
                }
                .padding(.top, 20)

                NavigationLink(destination: LoginPageView()) {
                    Text("Have an Account? Login Here")
                        .foregroundColor(.blue)
                        .padding()
                }

                .alert(isPresented: $resetSuccess) {
                                    Alert(title: Text("Oopsie"), message: Text("Please enter a valid email"),
                                          dismissButton: .default(Text("OK")))
                                            }

            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }

    func resetPassword() {
        PasswordResetFunctions.shared.resetPassword(email: email) { success, message in
            if success {
                resetSuccess = false
            } else {
                resetSuccess = true
            }
        }
    }

}

#Preview {
    PasswordResetView()
}
