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
        // .clipShape(.rect(topLeadingRadius: 10))
        .padding(.vertical, 20)
    }
}

struct SchoolScrollView: View {
    var colleges: [College]
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(colleges) { college in
                        NavigationLink(destination: SchoolView(viewModel: CollegeDetailViewModel(college: college))) {
                            GeometryReader(content: { proxy in
                                let cardSize = proxy.size
                                let minX = proxy.frame(in: .scrollView).minX - 60
                                // let minX = min(((proxy.frame(in: .scrollView).minX - 60) * 1.4), size.width * 1.4)
                                    
                                Image(college.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .offset(x: -minX)
                                    .frame(width: proxy.size.width * 1.5)
                                    .frame(width: cardSize.width, height: cardSize.height)
                                    .overlay {
                                        OverlayView(college)
                                    }
                                    .clipShape(.rect(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                
                            })
                            .frame(width: size.width - 120, height: size.height - 30)
                            .scrollTransition(.interactive, axis: .horizontal) {
                                view, phase in
                                view
                                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        }
                        }
                    }
                }
                .padding(.horizontal, 60)
                .scrollTargetLayout()
                .frame(height: size.height, alignment: .top)
                
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        })
        .frame(height: 300)
        .padding(.horizontal, -15)
        .padding(.top, 10)
            
        
    }
    @ViewBuilder
    func OverlayView(_ college: College) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(college.name)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                Text(college.city)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
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

var sampleColleges: [College] = [
    .init(id: "UVA", name: "University of Virginia", city: "Charlottesville, Virginia", description: "A lovely school", image: "UVA"),
    .init(id: "VT", name: "Virginia Tech", city: "Blacksburg, Virginia", description: "A lovely school", image: "VT"),
    .init(id: "JMU", name: "James Madison University", city: "Harrisonburg, Virginia", description: "A lovely school", image: "JMU"),
    .init(id: "GMU", name: "George Mason University", city: "Fairfax, Virginia", description: "A lovely school", image: "GMU"),
    .init(id: "W&M", name: "William and Mary", city: "Williamsburg, Virginia", description: "A lovely school", image: "WandM")
]

/*
#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
}
*/
#Preview {
    SchoolScrollView(colleges: sampleColleges)
}
