//
//  SwiftUIView.swift
//  CT
//
//  Created by Nate Owen on 12/27/23.
//

import SwiftUI
import Firebase


struct ProfilePage: View {
    @State private var showSignOutAlert = false
    @State private var showDeleteAlert = false
    @State private var showSplashScreen = true

    

    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
            if let user = viewModel.currentUser {
                List {
                    Section {
                        HStack {
                            Text(user.intitals)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72,height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading,spacing: 4){
                                Text(user.fullname)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Section("My Schools"){
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 25) {
                                ForEach(user.favorites, id: \.self) { imageName in
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .padding()
                                }
                            }
                            .padding(10) // Add padding to the HStack if needed
                        }
                        
                    }
                    Section("My Reviews"){
                        
                    }
                    Section("Account"){
                        
                        NavigationLink{
                            EditProfileView().environmentObject(AuthViewModel())
                                .navigationBarBackButtonHidden(false)
                        }
                    label: {
                        Text("Edit Profile")
                            .foregroundColor(.black)
                    }
                        
                        
                        
                        Button("Sign Out")
                        {
                            self.showSignOutAlert = true
                        }
                        .foregroundColor(.red)
                        .alert("Are you sure you want to sign out?", isPresented: $showSignOutAlert) {
                            Button("Yes") {
                                viewModel.signOut()
                            }
                            Button("No") {}
                        }
                        
                        
                        Button("Delete Account")
                        {
                            self.showDeleteAlert = true
                        }
                        .foregroundColor(.red)
                        .alert("Are you sure you want to delete your account?", isPresented: $showDeleteAlert) {
                            Button("Yes") {
                                viewModel.deleteAccount()
                            }
                            Button("No") {}
                        }
                        
                        
                    }
                }
            }
        }
    }
    


#Preview {
    ProfilePage().environmentObject(AuthViewModel())
}


