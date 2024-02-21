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
                    
                    Image("CTlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 2).delay(1)) {
                                self.scale = 20.0
                                self.opacity = 0.0
                            }
                        }
                }
            }
        }
    


#Preview {
    SplashScreenView()
}
