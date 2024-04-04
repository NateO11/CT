//
//  EditProfileView.swift
//  CT
//
//  Created by Nate Owen on 3/7/24.
//

import SwiftUI
import Firebase

struct EditProfileView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var textFieldInput: String = ""

    var body: some View {
//      Text("Edit Profile")
//        List{
//            TextField(viewModel.currentUser?.fullname ?? " ", text: $textFieldInput)
//        }
        
        VStack{
            Image("CTlogo2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
            Text("COMING SOON")
                .font(.title)
                .bold()
            Text("We promise!")
                .bold()
            Text("Sincerely, the CollegeTour team")
                .font(.caption)
        }
    }
}

#Preview {
    EditProfileView()
}
