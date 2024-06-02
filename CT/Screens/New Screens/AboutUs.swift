//
//  AboutUs.swift
//  CT
//
//  Created by Nate Owen on 6/2/24.
//
import SwiftUI

struct AboutUs: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading ){
                Text("Our Mission")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .bold()
                    .padding(.bottom)
                
                
                HStack {
                    Text("Our mission is to bridge the gap between high school and college by providing high school students with an authentic insight into college culture. Founded by two passionate entrepreneurs from the University of Virginia, our app empowers prospective college students to make informed decisions by accessing honest reviews and experiences shared by current students.")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                
                
            }
                HStack{
                    Image("stockimage2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 20)
                    Image("stockimage4")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 20)
                        .padding(.horizontal)
                    Image("CTlogo3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 20)
                    
                }
                .padding()
        }
    }
}

#Preview {
    AboutUs()
}
