//
//  HScroll.swift
//  CT
//
//  Created by Griffin Harrison on 2/1/24.
//

import Foundation
import SwiftUI
import MapKit
import Firebase


struct SchoolScrollView: View {
    @EnvironmentObject var authState: AuthViewModel
    var colleges: [College]
    var titleText: String
    var body: some View {
        VStack {
            HStack {
                Text(titleText)
                    .font(.title)
                    .bold()
                    .padding(.top,30)
                Spacer()
            }.padding(.horizontal, 20)
                .padding(.bottom, -10)
                .padding(.top, 5)
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        ForEach(colleges) { college in
                            if college.available {
                                NavigationLink(destination: SchoolView(viewModel: MapViewModel(college: college)).environmentObject(authState)) {
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
                                                AvailableOverlay(college: college)
                                                
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
                            } else {
                                NavigationLink(destination: EditProfileView()) {
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
                                            .blur(radius: 2)
                                            .overlay {
                                                UnavailableOverlay(college: college)
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
        .padding(.top, 20)
        }
            
        
    }
    
}

struct HScroll_Preview: PreviewProvider {
    static var previews: some View {
        SchoolScrollView(colleges: sampleColleges, titleText: "Test").environmentObject(AuthViewModel.mock)
    }
}


struct AvailableOverlay: View {
    @EnvironmentObject var authState: AuthViewModel
    var college: College
    @State var starred = false
    
    
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
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
        }
        .onAppear {
            starred = authState.currentUser?.favorites.contains(college.name) ?? false
        }
    }
}

struct AvailableOverlayNoStar: View {
    var college: College
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
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
        }
    }
}

struct UnavailableOverlay: View {
    var college: College
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [
                Color.gray,
                .gray.opacity(0.8),
                .gray.opacity(0.6),
                .gray.opacity(0.8),
                .gray
            ], startPoint: .top, endPoint: .bottom)
            Image("ComingSoon")
                .resizable()
                .opacity(0.5)
                .blur(radius: 0.5)
            VStack(alignment: .leading, spacing: 4, content: {
                Text(college.name)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.black)
                    .foregroundStyle(.white.opacity(0.8))
                Text(college.city)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        }
    }
}
