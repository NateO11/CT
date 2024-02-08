//
//  Authentication UI.swift
//  CT
//
//  Created by Nate Owen on 2/8/24.
//

import SwiftUI

struct AuthenticationUI: View {
    
    var innerText: String
    @Binding var variableName: String
    
    var body: some View {
        TextField(innerText, text: $variableName)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top)
    }
}
