//
//  SplashScreenView.swift
//  CT
//
//  Created by Nate Owen on 2/11/24.
//

import SwiftUI



struct SplashScreenView: View {
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
   // @State private var scale: Double = 1
    
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.white)
                .ignoresSafeArea(.all)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 3).delay(1)) {
                        self.opacity = 0.0
                    }
                }
            
            Image("CTMap")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .cornerRadius(20)
            
                Image("CTPin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                    .offset(x: 0, y: -90)
                    
                }
        }
    }

    


#Preview {
    SplashScreenView()
}
