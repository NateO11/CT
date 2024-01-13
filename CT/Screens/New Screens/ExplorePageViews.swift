//
//  ExplorePageViews.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit

struct TopButtonsSection: View {
    let userID: String
    @State private var userName: String = "Loading..."    
    
    var body: some View {
        VStack {
            ZStack {
                BlueRectangleView()
                   

                VStack(alignment: .leading) {
                
                    WelcomeNameText(userID: userID)
                    underlineRectangle()
                    explorePageTitleText()

                    HStack {
                        VStack(alignment: .leading) {
                            StyledButton(icon: "book", title: "Schools", destination: ProfilePage())
                            StyledButton(icon: "mappin", title: "Locations", destination: ProfilePage())
                        }
                        VStack(alignment: .leading) {
                            StyledButton(icon: "graduationcap", title: "Academics", destination: ProfilePage())
                            StyledButton(icon: "sportscourt", title: "Athletics", destination: ProfilePage())
                        }
                    }
                }
                .padding(.leading, 20)
            }
        }
        .padding(.bottom, 10)
    }
}

struct LargeImageSection: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        ZStack {
            largeImageBackground(imageName: imageName)

            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                largeImageTitleText(text: title)
                largeImageSmallText(text: description)
                largeMapsButton() // Customize this as needed
            }
            .padding()
        }
        .padding(.vertical, 20)
    }
}

struct HorizontalSchoolsScrollView: View {
    var colleges: [College]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(colleges, id: \.id) { college in
                    GeometryReader { geometry in
                        NavigationLink(destination: SchoolView(viewModel: CollegeDetailViewModel(college: college))) {
                            SchoolCard(college: college)
                                .rotation3DEffect(
                                    .degrees(-Double(geometry.frame(in: .global).minX) / 20),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .scaleEffect(scaleValue(geometry: geometry))
                        }
                    }
                    .frame(width: 250, height: 300)
                }
            }
            .padding(.horizontal)
        }
    }

    private func scaleValue(geometry: GeometryProxy) -> CGFloat {
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



struct SchoolCard: View {
    let college: College
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
            VStack(alignment: .leading) {
                Image(college.image) // Assuming imageName is the name of the image in the assets
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                    .clipped()
                    .shadow(radius: 10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(college.name)
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(.black)
                    Text(college.city)
                        .fontWeight(.regular)
                        .font(.caption)
                        .foregroundColor(.black)
                   
                }
            }
            .padding(30)
        }
    }
}



struct WelcomeNameText: View {
    let userID: String
    @State private var name: String = "placeholdername"

    var body: some View {
        Text("Welcome \(userID)")
            .font(.title)
            .padding(.bottom, 1)
            .foregroundColor(.white)
            .onAppear {
                // Fetch the username based on userID
                // Example: self.name = fetchUsername(forID: userID)
            }
    }
}


struct BlueRectangleView: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(height: 300)
            .edgesIgnoringSafeArea(.all)
    }
      
}


struct explorePageTitleText: View {
    var body: some View {
        Text("Explore Schools")
            .font(.largeTitle)
            .padding(.bottom)
            .foregroundColor(.white)
            .bold()
            .fontWeight(.heavy)
    }
}


struct underlineRectangle: View {
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 250,height: 1)
            .edgesIgnoringSafeArea(.all)
    }
}

struct StyledButton<Destination: View>: View {
    let icon: String
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .bold()
                Text(title)
                    .foregroundColor(.blue)
                    .padding(.leading, 5)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
        .frame(width: 160, height: 60)
        .background(Color.white)
        .cornerRadius(40)
    }
}

struct StyledButtonDark<Destination: View>: View {
    let icon: String
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .bold()
                Text(title)
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                    .bold()
                    .fontWeight(.heavy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
        .frame(width: 160, height: 60)
        .background(Color.black)
        .cornerRadius(40)
    }
}



struct largeImageBackground: View {
    
    let imageName: String
    
    var body: some View {
        
        Image(imageName)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct largeImageTitleText: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.white)
    }
}

struct largeImageSmallText: View {
    
    let text: String

    var body: some View {
        
        Text(text)
            .font(.headline)
            .foregroundColor(.white)

    }
}

struct largeReviewsButton: View {
    var body: some View {
        
        Button(action: { }) {
            Text("Reviews")
                .foregroundColor(.black)
                .padding()
                .bold()
                .background(Color.white)
                .cornerRadius(30)
        }
    }
}

struct largeMapsButton: View {
    var body: some View {
        
        HStack{
            Spacer()
            Button(action: { }) {
                Text("View Maps")
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .background(Color.white)
                    .cornerRadius(30)
            }
        }
    }
}


struct bottomText: View {
  
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(.caption2)
            .fontWeight(.thin)
            
    }
}


struct xButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "xmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.black)
            .frame(width: 12,height: 12)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
        }
    }


#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
}
