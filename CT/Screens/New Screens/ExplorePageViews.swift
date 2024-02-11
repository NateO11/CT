//
//  ExplorePageViews.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit
import Firebase

struct TopButtonsSection: View {
    let userID: String
    @State private var userName: String = "Loading..."    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, .black.opacity(0.85)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
            
                WelcomeNameText(userID: userID)
                underlineRectangle()
                explorePageTitleText()

                HStack {
                    VStack(alignment: .leading) {
                        StyledButton(icon: "book", title: "Schools", destination: ProfilePage(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2"))
                        StyledButton(icon: "mappin", title: "Locations", destination: ProfilePage(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2"))
                    }
                    VStack(alignment: .leading) {
                        StyledButton(icon: "graduationcap", title: "Academics", destination: ProfilePage(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2"))
                        StyledButton(icon: "sportscourt", title: "Athletics", destination: ProfilePage(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2"))
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.leading, 20)
            .padding(.bottom, 30)
            .padding(.top, 60)
        }

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
                HStack(spacing: 10) {
                    largeImageSmallText(text: description)
                    largeMapsButton(colleges: sampleColleges)
                }
            }
            .padding()
        }
        .clipShape(.rect(bottomLeadingRadius: 10, bottomTrailingRadius: 10))
        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
        .padding(.vertical, 20)
    }
}

struct subTitleText: View {
    let text: String
    let subtext: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .padding(.top, 40)
                .bold()
            
            Text(subtext)
                .padding(.bottom, 30)

        }
    }
}

struct largeImageBackground: View {
    
    let imageName: String
    
    var body: some View {
        
        Image(imageName)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .overlay {
                LinearGradient(colors: [.clear, .clear, .clear, .black.opacity(0.1), .black.opacity(0.5), .black], startPoint: .top, endPoint: .bottom)
            }
        
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
    
    var colleges: [College]

    var body: some View {
        
        HStack {
            Spacer()
            NavigationLink(destination: SearchView(colleges: sampleColleges)) {
                Text("View Schools")
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .background(Color.white)
                    .cornerRadius(30)
            }
        }
    }
}

struct WelcomeNameText: View {
    var userID: String
    @State private var username: String = "Default Username"

    var body: some View {
        Text("Welcome, \(username)!")
            .font(.title)
            .padding(.bottom, 1)
            .foregroundColor(.white)
            .onAppear {
                fetchUserData()
            }
    }
    
    private func fetchUserData() {
        let db = Firestore.firestore()

        // Query the Users collection for the provided UserID
        db.collection("Users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }

            if let userDoc = document {
                let username = userDoc["Username"] as? String ?? "Default Username"
                DispatchQueue.main.async {
                    self.username = username
                }
            } else {
                print("User not found")
            }
        }
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
                    .foregroundColor(.black)
                    .bold()
                Text(title)
                    .foregroundColor(.black)
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
    .init(id: "UVA", available: true, name: "University of Virginia", city: "Charlottesville, Virginia", description: "A lovely school", image: "UVA"),
    .init(id: "VT", available: true, name: "Virginia Tech", city: "Blacksburg, Virginia", description: "A lovely school", image: "VT"),
    .init(id: "JMU", available: true, name: "James Madison University", city: "Harrisonburg, Virginia", description: "A lovely school", image: "JMU"),
    .init(id: "GMU", available: true, name: "George Mason University", city: "Fairfax, Virginia", description: "A lovely school", image: "GMU"),
    .init(id: "W&M", available: true, name: "William and Mary", city: "Williamsburg, Virginia", description: "A lovely school", image: "WandM")
]


#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholdr")
}
