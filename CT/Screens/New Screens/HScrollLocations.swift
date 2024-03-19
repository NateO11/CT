//
//  HScrollLocations.swift
//  CT
//
//  Created by Griffin Harrison on 2/29/24.
//

import Foundation
import SwiftUI
import MapKit
import Firebase


struct LocationScrollView: View {
    @EnvironmentObject var authState: AuthViewModel
    var college: College
    var topLocations: [Location]
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(topLocations) { location in
                        NavigationLink(destination: MapView(viewModel: MapViewModel(college: college), initialSelectedLocation: location).environmentObject(authState)) {
                            GeometryReader(content: { proxy in
                                let cardSize = proxy.size
                                let minX = proxy.frame(in: .scrollView).minX - 60
                                // let minX = min(((proxy.frame(in: .scrollView).minX - 60) * 1.4), size.width * 1.4)
                                    
                                if location.imageLink == "" {
                                    Image(college.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .offset(x: -minX)
                                        .frame(width: proxy.size.width * 1.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay {
                                            OverlayView(college, location)
                                        }
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                } else {
                                    AsyncImage(url: URL(string: location.imageLink)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.black
                                    }
                                    .offset(x: -minX)
                                    .frame(width: proxy.size.width * 1.5)
                                    .frame(width: cardSize.width, height: cardSize.height)
                                    .overlay {
                                        OverlayView(college, location)
                                    }
                                    .clipShape(.rect(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                }
                                
                                
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
    func OverlayView(_ college: College, _ location: Location) -> some View {

        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                Color.clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Spacer()
                Text(location.name)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                Text(location.category)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
        
    }
}

struct HScroll_Preview2: PreviewProvider {
    static var previews: some View {
        LocationScrollView(college: sampleColleges[2], topLocations: sampleLocations).environmentObject(AuthViewModel.mock)
    }
}
