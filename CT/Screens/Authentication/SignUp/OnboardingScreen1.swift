//
//  OnboardingScreen1.swift
//  CT
//
//  Created by Nate Owen on 2/20/24.
//


import SwiftUI

struct OnboardingScreen1: View {
    
   
    
    var body: some View {
        NavigationStack{
            
            VStack{
                Text("Welcome to CollegeTour!")
                    .font(.title)
                    .bold()
                    
                Text("I am a...")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                VStack{
                    OnboardButton1(innertext: "Highschool Student", selection: "Highschool")
                    OnboardButton1(innertext: "College Student",selection: "College")
                    OnboardButton1(innertext: "Parent", selection: "Parent")
                    OnboardButton1(innertext: "Other",selection: "Other")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingScreen2: View {
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("My School is ... ")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                OnboardButton2(innertext: "Virginia", selection: "UVA")
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



struct OnboardButton1: View{
    
    var innertext: String
    var selection: String
    
    
    
    
    var body: some View {
        NavigationStack {
            Button(action: {
                Task {
                    SignUpFunctions.shared.addPositionToUser(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2", position: self.selection)
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 300, height: 70)
                        .scaledToFill()
                        .shadow(radius: 20)
                
                    Text(innertext)
                        .font(.title)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .bold()
                }
                .padding()
            }
            
            NavigationLink(destination: OnboardingScreen2()) {
                EmptyView()
            }
            .navigationBarHidden(true)
        }
    }

}



struct OnboardButton2: View{
    
    var innertext : String
    var selection: String

    
    var body: some View {
        NavigationStack {
            Button(action: {
                Task {
                    SignUpFunctions.shared.addSchoolToUser(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2", school: self.selection)
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 300, height: 70)
                        .scaledToFill()
                        .shadow(radius: 20)
                
                    Text(innertext)
                        .font(.title)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .bold()
                }
                .padding()
            }
            
            NavigationLink(destination: PasswordResetView()) {
                EmptyView()
            }
            .navigationBarHidden(true)
        }
    }

}


#Preview {
    OnboardingScreen1()
}
