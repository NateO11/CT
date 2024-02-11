//
//  SwiftUIView.swift
//  CT
//
//  Created by Nate Owen on 12/27/23.
//

import SwiftUI
import Firebase

struct UserProfile {
    var name: String
}

struct ProfilePage: View {
    
    @State private var user: UserProfile?
    var userID: String
    
    var body: some View {
        ScrollView{
            VStack {
                HStack{
                    Text("Account")
                        .font(.largeTitle)
                        .padding(.top, 10)
                        .bold()
                    
                    Spacer()
                    
                    // Edit Button
                    Button(action: {}) {
                        Text("Settings")
                            .padding()
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    .padding(.top, 20)
                    
                }
                .padding(.horizontal)
                HStack{
                    // Profile Picture
                    Image("UVA")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding(.horizontal)
                    
                    // Name
                    VStack(alignment: .leading){
                        //       let supposedID = authState.currentUserId ?? "ratio"
                        Text(user?.name ?? "Loading...")
                            .font(.title)
                            .padding()
                            .bold()
                            .onAppear {
                                fetchUserData()
                            }
                    }
                }
                HStack{
                    Text("My Schools:")
                        .font(.title2)
                        .padding()
                        .bold()
                    Spacer()
                }
                
                HStack{
                    Text("My Reviews:")
                        .font(.title2)
                        .padding()
                        .bold()
                    Spacer()
                }
                
            }
        }
    }
        
        func fetchUserData() {
            let db = Firestore.firestore()
            
            // Query the Users collection for the provided UserID
            db.collection("Users").whereField("UserID", isEqualTo: userID).getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error ?? NSError())")
                    return
                }
                
                // Assuming there's only one document for the given UserID
                if let userDoc = documents.first {
                    let username = userDoc["Username"] as? String ?? "Default Username"
                    self.user = UserProfile(name: username)
                } else {
                    print("User not found")
                }
            }
        }
    }
    


        
#Preview {
    ProfilePage(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2")
}
