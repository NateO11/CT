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
    @State private var resetfailed: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // styles for textfield and image
                AuthTitleAndImage(title: "Reset Password")
                AuthTextFieldStyle(innerText: "Enter Email", variableName: $email)
                
                // style for button
                Button(action: { resetPassword() }) {
                    AuthButtonStyle(buttonText: "Reset")
                }
                .padding(.top, 20)
                
                
//                
//                NavigationLink(destination: LoginPageView(authViewModel: AuthViewModel)) {
//                    Text("Have an Account? Login Here")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//                
                
                // pop to alert users to enter a valid email
                .alert(isPresented: $resetfailed) {
                    Alert(title: Text("Oopsie"), message: Text("Please enter a valid email"),
                          dismissButton: .default(Text("OK")))
                }
                
            }
            .padding()
        }
        // hides back button when navigating to a new page
        .navigationBarBackButtonHidden(true)
    }

    
// This function calls the reset password function in the PasswordResetFunctions folder and uses the current email as an argument. This fucntion should automatically send an email to the user to change their current password
    func resetPassword() {
        PasswordResetFunctions.shared.resetPassword(email: email) { success, message in
            if success {
                resetfailed = false
            } else {
                resetfailed = true
            }
        }
    }
    
}

#Preview {
    PasswordResetView()
}
