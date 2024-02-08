//
//  SchoolPage.swift
//  CT
//
//  Created by Griffin Harrison on 2/1/24.
//

import Foundation
import SwiftUI
import MapKit
import Firebase

struct SchoolView: View {
    var college: College

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 90)
                    
                    // Horizontal Scroll of Photos
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(1..<5) { _ in
                                Image(college.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 200)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .frame(height: 200)
                    .padding(.bottom, 5) // Adjust spacing as needed
                    
                    // School Information
                    Text(college.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.bottom, 10)
                    
                    Text(college.city)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    
                    Text(college.description)
                        .padding(.bottom, 10)
                    
                    // Navigation Buttons
                    HStack {
                        StyledButtonDark(icon: "mappin", title: "View Map", destination: MapView(viewModel: MapViewModel(college: college)))
                    }
                    
                    LocationHorizontalScrollView(title: "Locations", description: "Prominent spots around campus", images: [college.image])
                    
                    subTitleText(text: "Categories", subtext: "Hear what students have to say about...")
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 330, height: 250)
                            .foregroundColor(Color.blue.opacity(0.3)) // Adjust the opacity value as needed
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Adjust the shadow properties as needed
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                SubCategoryButton(icon: "g.square", title: "Greek Life", forum: "Greek", college: college)
                                SubCategoryButton(icon: "gear", title: "Engineering", forum: "Engineering", college: college)
                            }
                            HStack {
                                SubCategoryButton(icon: "book", title: "Business", forum: "Business", college: college)
                                SubCategoryButton(icon: "leaf", title: "Dining", forum: "Dining", college: college)
                            }
                            HStack {
                                SubCategoryButton(icon: "football", title: "Athletics", forum: "Athletics", college: college)
                                SubCategoryButton(icon: "pencil", title: "Other", forum: "Other", college: college)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    SchoolCardReviews(college: college.name)
                    
                    LocationHorizontalScrollView(title: "Libraries", description: "Read about where students study", images: [college.image])
                }
                .padding()
            }
            .ignoresSafeArea()

        
        .navigationBarTitle(college.name)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
    }
    private func photoScaleValue(geometry: GeometryProxy) -> CGFloat {
            var scale: CGFloat = 1.0
            let offset = geometry.frame(in: .global).minX

            // Adjust these values to control the scale
            let threshold: CGFloat = 100
            if abs(offset) < threshold {
                scale = 1 + (threshold - abs(offset)) / 500
            }

            return scale
        }
     
}


struct LocationHorizontalScrollView: View {
    let title: String
    let description: String
    let images: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .padding(.top, 40)
                .bold()

            Text(description)
                .padding(.bottom, 30)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 225)
                            .clipped()
                            .cornerRadius(10)
                    }
                }
            }
            .frame(height: 200)
            .padding(.bottom, 10)
        }
    }
}

struct SubCategoryButton: View {
    var icon: String
    var title: String
    var forum: String
    var college: College

    var body: some View {
        NavigationLink(destination: ForumsTemplate(college: college.name, forum: forum)) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20) // Set a fixed size for the image

                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading) // Allow text to take remaining space
            }
            .padding()
            .background(Color.black)
            .cornerRadius(30)
            .frame(width: 150, height: 60) // Set a fixed size for the entire button
        }
        .buttonStyle(PlainButtonStyle()) // Remove the default button style
        
    }
}


struct SchoolCardReviews: View {
    var college: String

    var body: some View {
        
        subTitleText(text: "Reviews", subtext: "Where current students voice their opinons")

        
        NavigationLink(destination: ForumsTemplate(college: college, forum: "General")) {
            VStack {
                
                Text("Read Reviews")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20)

                Spacer()
            }
        }
        .navigationBarTitle("")  // To hide the default "Back" button text
        .navigationBarHidden(true) // To hide the navigation bar when transitioning
    }
}
