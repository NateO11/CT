////
////  passwordReset.swift
////  CT
////
////  Created by Nate Owen on 12/15/23.
////
//
//import SwiftUI
//import Firebase
//
//struct passwordReset: View {
//    
//    @State private var email: String = ""
//    @State private var resetSuccessMessage: Bool?
//
//
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Reset Password")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .padding()
//                
//                Image("CTlogo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 100, height: 100)
//                    .padding(.bottom, 30)
//                
//                TextField("Email", text: $email)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding()
//                    .shadow(radius: 10)
//                
//                Button(action: { resetPass() }) {
//                    Text("Reset")
//                        .font(.title)
//                        .frame(width: 200, height: 60)
//                        .background(Color.black)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 5)
//                }
//                NavigationLink(destination: LoginPageView()) {
//                    Text("Have an Account? Login Here")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//                if resetSuccessMessage != nil {
//                    Text("Check your inbox for a Reset Password Email")
//                        .foregroundColor(.green)
//                        .padding()
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//func resetPass() {
//    Auth.auth().sendPasswordReset(withEmail: email) { error in
//        if let error = error {
//            print("Error resetting password: \(error.localizedDescription)")
//        } else {
//            print("Password reset email sent successfully.")
//            resetSuccessMessage = true
//            }
//        }
//    }
//}
//
//
//#Preview {
//    passwordReset()
//}
