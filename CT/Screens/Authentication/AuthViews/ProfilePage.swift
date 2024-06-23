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

    // @ObservedObject var profileViewModel: ProfileViewModel

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
                    Section("My Reviews"){
                        if (viewModel.currentUser!.reviews.isEmpty) {
                            Text("Write some reviews")
                        } else {
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    ForEach(viewModel.currentUser!.reviews, id: \.text) { review in
                                        let firstChar = Array(review.userID)[0]
                                        IndividualReviewView(review: review, firstChar: String(firstChar).uppercased(), isProfilePage: true, isStars: false)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        viewModel.fetchReviews()
                    }
                    Section("Account"){
                        
                        NavigationLink{
                            EditProfileView().environmentObject(AuthViewModel())
                                .navigationBarBackButtonHidden(false)
                        }
                    label: {
                        Text("Edit Profile")
                            .foregroundColor(Color("UniversalFG"))
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
    ProfilePage().environmentObject(AuthViewModel.mock)
}


