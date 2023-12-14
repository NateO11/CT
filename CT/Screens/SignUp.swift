//
//  SignUp.swift
//  CT
//
//  Created by Nate Owen on 12/14/23.
//

import SwiftUI
import Firebase


struct SignUp: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var confirmPassword: String = ""
    @State private var signedIn: Bool = false
    
    
    var body: some View {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 30)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .shadow(radius: 10)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                TextField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                TextField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
            }
            .padding()
            Button(action: {
                createUser()
                
            }) {
                Text("Sign Up")
                    .font(.title)
                    .frame(width: 200, height: 60)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Text("Existing User? Sign In Here")
                .foregroundColor(.blue)
                .padding()
                .onTapGesture {
                   // LoginPage()
                }
}
    
    func createUser(){
        if (email != "" && password != "" && username != "" && confirmPassword != ""){
            if(confirmPassword == password){
                Auth.auth().createUser(withEmail: email, password: password){ (res, err) in
                    if err != nil{
                        print("\(String(describing: err))")
                        return
                    }
                    else{
                        createUserInfo()
                    }
                }
            }
        }
        func createUserInfo() {
            
            let db = Firestore.firestore()
            let userEmail = Auth.auth().currentUser?.email ?? ""
            let userID = Auth.auth().currentUser?.uid
            
            // variable name
            let userRef = db.collection("Users").document(userID!)
                
                // Update existing document or create a new one
                userRef.setData(["UserEmail": userEmail,"Username": username, "Password": password, "UserID": userID!]) { error in
                    if error != nil {
                        print("Error updating document")
                    } else {
                        print("Document successfully written or updated.")
                        signedIn = true
                    }
                }
            }
            
        }
    }



#Preview {
    SignUp()
}
