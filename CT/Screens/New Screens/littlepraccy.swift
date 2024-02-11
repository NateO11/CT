//
//  littlepraccy.swift
//  CT
//
//  Created by Nate Owen on 2/11/24.
//

import SwiftUI

struct littlepraccy: View {
        @State private var isSplashScreenActive = true
    
    var body: some View {
        ZStack {
            // Your main content goes here
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            // Splash screen view with animation
            if isSplashScreenActive {
                SplashScreenView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5))
                    .onAppear {
                        // After a delay, hide the splash screen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                isSplashScreenActive = false
                            }
                        }
                    }
            }
        }
    }
}

struct SlashScreenView: View {
    var body: some View {
        // Customize your splash screen view here
        VStack {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            
            Text("Your App Name")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 10)
        }
    }
}

#Preview {
    littlepraccy()
}
