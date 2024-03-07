//
//  practiceView.swift
//  CT
//
//  Created by Nate Owen on 3/7/24.
//

import SwiftUI

struct practiceView: View {
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
                    
                }
                Section("My Reviews"){
                    
                }
                Section("Account"){
                    Button{
                        viewModel.signOut()
                    }label: {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                    Button{
                        viewModel.deleteAccount()
                    }label: {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    practiceView()
}
