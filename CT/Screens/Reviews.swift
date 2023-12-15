//
//  Reviews.swift
//  CT
//
//  Created by Griffin Harrison on 12/10/23.
//

import SwiftUI


struct Reviews: View {

    
    var body: some View {
      
                HStack {
                    Button(action: {
                    }) {
                        Text("Reviews")
                            .font(.headline)
                            .bold()
                            .frame(width: 150, height: 60)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                    }) {
                        Text("General")
                            .font(.headline)
                            .bold()
                            .frame(width: 150, height: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
        Spacer()
            }
        }

#Preview {
    Reviews()
}
