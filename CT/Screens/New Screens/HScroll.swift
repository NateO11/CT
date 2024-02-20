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
    var colleges: [College]
    @State private var showAlert: Bool = false
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(colleges) { college in
                        if college.available {
                            NavigationLink(destination: SchoolView(college: college)) {
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
                                            OverlayView(college, available: college.available)
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
                                        OverlayView(college, available: college.available)
                                    }
                                    
                                    .clipShape(.rect(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                    .onTapGesture {
                                        showAlert = true
                                    }
                                    .alert(isPresented: $showAlert) {
                                        Alert(
                                            title: Text("School unavailable"),
                                            message: Text("\(college.name) \n is coming soon!"),
                                            dismissButton: .default(Text("OK"))
                                        )
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
    func OverlayView(_ college: College, available: Bool) -> some View {

        if available {
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
                    HStack {
                        Spacer()
                        starButton(starred: false)
                    }
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
            })
        } else {
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
}

#Preview {
    SchoolScrollView(colleges: sampleColleges)
}
