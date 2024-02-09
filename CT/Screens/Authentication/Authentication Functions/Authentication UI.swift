//
//  Authentication UI.swift
//  CT
//
//  Created by Nate Owen on 2/8/24.
//

import SwiftUI

struct AuthTextFieldStyle: View {
    
    
    // input vars for the gray text within, and the name of the variable being passed in to store the inputted value
    //thats why we use BINDING , it allows the variable information to be changed within different files
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


struct AuthButtonStyle: View {
   
    var buttonText: String
    
    var body: some View {
        Text(buttonText)
            .font(.title)
            .frame(width: 200, height: 60)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}


