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
    
    @State private var user = UserProfile(name: "Nate  Owen", school: "Swift University", profilePicture: "UVA")
    
    
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
                        Text("Edit")
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
                        .aspectRatio(contentMode: .fit)
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
                Spacer()
            }
            .padding()
        }
    }
    
}

#Preview {
    ProfilePage()
}
