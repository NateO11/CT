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
        Text("Edit Profile")
        List{
            TextField(viewModel.currentUser?.fullname ?? " ", text: $textFieldInput)
        }
    }
}

#Preview {
    EditProfileView()
}
