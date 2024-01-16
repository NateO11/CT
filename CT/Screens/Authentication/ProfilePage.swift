//
//  SwiftUIView.swift
//  CT
//
//  Created by Nate Owen on 12/27/23.
//

import SwiftUI

struct UserProfile {
    var name: String
    var school: String
    var profilePicture: String
}

struct ProfilePage: View {
    
    @State private var user = UserProfile(name: "Nate Owen", school: "Swift University", profilePicture: "UVA")
    // add in the list of schools they like and the list of reviews
//    @EnvironmentObject var authState: AuthState
        
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
                            .background(Color.gray)
                            .cornerRadius(20)
                    }
                    .padding(.top, 20)
                    
                }
                HStack{
                    // Profile Picture
                    Image(user.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding(.horizontal)
                    
                    // Name
                    VStack{
                        Text(user.name)
                            .font(.title)
                            .padding(.top, 10)
                            .padding(.horizontal)
                            .bold()
                        
                        // School
                        Text(user.school)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                }
                VStack(alignment: .leading){
             //       let supposedID = authState.currentUserId ?? "ratio"

                    Text("Your Schools")
                        .font(.title2)
                        .padding(.top, 10)
                        .bold()
              //      Text(supposedID)
                        .font(.title2)
                        .padding(.top, 10)
                        .bold()
                    
                    List{
                        //list of schools they have favorited
                    }
                    
                    Text("Your Reviews")
                        .font(.title2)
                        .padding(.top, 10)
                        .bold()
                    
                    List{
                        // list of reviews written
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
    
}

#Preview {
    ProfilePage()
}
