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
    }
}



// style for login and signup buttons

struct AuthButtonStyle: View {
   
    var buttonText: String
    
    var body: some View {
        Text(buttonText)
            .font(.title)
            .frame(width: 200, height: 60)
            .background(Color("UniversalFG").gradient)
            .foregroundColor(Color("UniversalBG"))
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct AuthTitleAndImage: View {
   
    var title: String
    
    var body: some View {
        VStack {

            Image("CTlogo3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            
            Text(title)
                .padding(.top, 30)
                .font(.largeTitle)
                .bold()
        }
    }
}


