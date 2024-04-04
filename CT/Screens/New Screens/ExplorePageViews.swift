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


struct LargeImageSection: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .overlay {
                    LinearGradient(colors: [.clear, .clear, .clear, .black.opacity(0.1), .black.opacity(0.5), .black], startPoint: .top, endPoint: .bottom)
                }

            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                HStack(spacing: 10) {
                    Text(description)
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack {
                        Spacer()
                        NavigationLink(destination: EditProfileView()) {
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
            .padding()
        }
        .clipShape(.rect(bottomLeadingRadius: 10, bottomTrailingRadius: 10))
        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
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

struct starButton: View {
    @State var starred: Bool
    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(self.starred == true ? .yellow : .gray)
            .frame(width: 25,height: 25)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
        
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
        .frame(width: 180, height: 60)
        .background(Color.black)
        .cornerRadius(40)
    }
}


var sampleColleges: [College] = [
    .init(id: "UVA", available: true, name: "University of Virginia", city: "Charlottesville, Virginia", description: "A lovely school", image: "UVA", coordinate: CLLocationCoordinate2D(latitude: 38, longitude: -77.1), color: Color.orange),
    .init(id: "VT", available: true, name: "Virginia Tech", city: "Blacksburg, Virginia", description: "A lovely school", image: "VT", coordinate: CLLocationCoordinate2D(latitude: 36, longitude: -77), color: .red),
    .init(id: "JMU", available: true, name: "James Madison University", city: "Harrisonburg, Virginia", description: "A lovely school", image: "JMU", coordinate: CLLocationCoordinate2D(latitude: 37, longitude: -77.2), color: .purple),
    .init(id: "GMU", available: true, name: "George Mason University", city: "Fairfax, Virginia", description: "A lovely school", image: "GMU", coordinate: CLLocationCoordinate2D(latitude: 39, longitude: -77.5), color: .green),
    .init(id: "W&M", available: true, name: "William and Mary", city: "Williamsburg, Virginia", description: "A lovely school", image: "WandM", coordinate: CLLocationCoordinate2D(latitude: 38, longitude: -76), color: .green)
]


var sampleLocations: [Location] = [
    .init(id: "1", name: "Rotunda", description: "idk", coordinate: CLLocationCoordinate2D(latitude: 17, longitude: 18), category: "Landmarks", imageLink: "https://firebasestorage.googleapis.com/v0/b/collegetour-fb638.appspot.com/o/clarkLibrary.jpeg?alt=media&token=81f2a8dc-c47d-4a39-a66d-69f1f06f21e3"),
    .init(id: "2", name: "Runk", description: "I love runnk girl", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 18), category: "Dining", imageLink: "https://firebasestorage.googleapis.com/v0/b/collegetour-fb638.appspot.com/o/rotunda.jpeg?alt=media&token=dea66a98-10b6-4a0c-8b45-618650023cbd")
]
