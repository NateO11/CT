//
//  LocationInfo.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import MapKit


struct AlternateLocationView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: LocationViewModel
    @EnvironmentObject var bookmarks: Bookmarks

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Background Image
                AsyncImage(url: URL(string: viewModel.location.imageLink)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .overlay {
                            LinearGradient(colors: [.clear, .clear, .clear, .black.opacity(0.1), .black.opacity(0.3), .black.opacity(0.4), .black.opacity(0.5), .black.opacity(0.7), .black.opacity(0.9), .black, .black], startPoint: .top, endPoint: .bottom)
                        }
                } placeholder: {
                    Color.black
                }
                VStack(alignment: .leading) {
                    Text("\(viewModel.college.name) - \(viewModel.location.category)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        
                    
                    Text(viewModel.location.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    HStack {
                        Spacer() // Pushes the buttons to center
                        Button {
                            if bookmarks.contains(viewModel.location) {
                                bookmarks.remove(viewModel.location, for: viewModel.college)
                                } else {
                                    bookmarks.add(viewModel.location, for: viewModel.college)
                                }
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: bookmarks.contains(viewModel.location) ? "bookmark.fill" : "bookmark")
                                Text(bookmarks.contains(viewModel.location) ? "Unsave" : "Save")
                                    .font(.caption)
                                    .bold()
                            }
                            .padding(.vertical, 10)
                            .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.15)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }.tint(.white)
                            
                        
                        ShareLink(item: URL(string: "https://www.virginia.edu/")!, subject: Text("Download College Tour!"), message: Text("Check out this spot at \(viewModel.college.name) in College Tour!")) {
                                VStack(spacing: 5) {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share")
                                        .font(.caption)
                                        .bold()
                                }
                                .padding(.vertical, 10)
                                .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.15)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                        }.tint(.white)
                        
                        Button {
                            openURL(URL(string: "http://maps.apple.com/?q=\(viewModel.location.name)&ll=\(String(viewModel.location.coordinate.latitude)),\(String(viewModel.location.coordinate.longitude))")!)
                        } label: {
                                VStack(spacing: 5) {
                                    Image(systemName: "mappin.circle")
                                    Text("Directions")
                                        .font(.caption)
                                        .bold()
                                }
                                .padding(.vertical, 10)
                                .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.15)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                        }.tint(.white)
                        
                        Spacer() // Pushes the buttons to center
                    }
                    .frame(maxWidth: .infinity) // Ensure the HStack stretches across the width
                    .padding(.bottom, 20)
                }
                .padding()
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}





struct StarRating: View {
    struct ClipShape: Shape {
        let width: Double
        
        func path(in rect: CGRect) -> Path {
            Path(CGRect(x: rect.minX, y: rect.minY, width: width, height: rect.height))
        }
    }
    
    let rating: Double
    let maxRating: Int
    
    init(rating: Double, maxRating: Int) {
        self.maxRating = maxRating
        self.rating = rating
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Text(Image(systemName: "star.fill"))
                    .foregroundColor(.gray)
                    .aspectRatio(contentMode: .fill)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
            }
        }.overlay(
            GeometryReader { reader in
                HStack(spacing: 0) {
                    ForEach(0..<maxRating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .clipShape(
                    ClipShape(width: (reader.size.width / CGFloat(maxRating)) * CGFloat(rating))
                )
            }
        )
    }
}
