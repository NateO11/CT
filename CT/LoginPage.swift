//
//  LoginPage.swift
//  CT
//
//  Created by Nate Owen on 12/10/23.
//

import SwiftUI

struct LoginPage: View {
    @State private var username: String = ""
        @State private var password: String = ""
        
        var body: some View {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 30)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                Button(action: {
                    // Handle login logic here
                    // You would typically check the entered username and password
                    // against your authentication system
                    // If valid, navigate to the next screen, else show an error
                    print("Login tapped")
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
