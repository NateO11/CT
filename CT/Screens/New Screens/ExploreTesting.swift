//
//  ExploreTesting.swift
//  CT
//
//  Created by Griffin Harrison on 2/23/24.
//

import Foundation
import SwiftUI
import MapKit
import Firebase


struct ExploreTesting: View {
    @State var offsetY: CGFloat = 0
    @State var showSearch: Bool = false
    var body: some View {
        GeometryReader{proxy in
            let safeAreaTop = proxy.safeAreaInsets.top
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HeaderView(safeAreaTop)
                        .offset(y: -offsetY)
                        .zIndex(1)
                    
                    VStack {
                        SchoolScrollView(colleges: sampleColleges)
                        LargeImageSection(imageName: "stockimage1", title: "I like men", description: "Especially younger men")
                        SchoolScrollView(colleges: sampleColleges)
                        LargeImageSection(imageName: "stockimage3", title: "I like men", description: "Especially younger men")
                        bottomText(text: "Contact us at CollegeTour@gmail.com")
                    }
                    .zIndex(0)

                }
                .offset(coordinateSpace: .named("SCROLL")) { offset in
                    offsetY = offset
                    showSearch = (-offset > 80) && showSearch
                }
            }
            .coordinateSpace(name: "SCROLL")
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    
    @ViewBuilder
    func HeaderView(_ safeAreaTop: CGFloat)-> some View {
        let progress = -(offsetY / 80) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    TextField("Search", text: .constant(""))
                        .tint(.blue)
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .opacity(0.25)
                }
                .opacity(showSearch ? 1 : 1+progress)
                
                Button {
                    
                } label: {
                    Image("UVA")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }
                }
                .opacity( showSearch ? 0 : 1)
                .overlay {
                    if showSearch {
                        Button {
                            showSearch = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            HStack(spacing: 15) {
                CustomButton(symbolImage: "map.fill", title: "Schools") {
                }
                CustomButton(symbolImage: "star.fill", title: "Favorites") {
                }
                
            }
            .padding(.horizontal, -progress*50)
            .padding(.vertical, 10)
            .offset(y:progress*65)
            .opacity(showSearch ? 0: 1)
        }
        .overlay(alignment: .topLeading) {
            Button {
                showSearch = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .offset(x: 13, y:10)
            .opacity(showSearch ? 0 : -progress)
        }
        .animation(.easeInOut(duration: 0.2), value: showSearch)
        .padding([.horizontal, .bottom], 15)
        .padding(.top, safeAreaTop + 10)
        .background {
            Rectangle()
                .fill(LinearGradient(colors: [Color.blue, .blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(.bottom, -progress*75)
        }
        
    }
    
    @ViewBuilder
    func CustomButton(symbolImage: String, title: String, onClick: @escaping()->())-> some View {
        Button {
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                HStack(spacing: 0) {
                    Image(systemName: symbolImage)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(width: 40, height: 40)
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .foregroundColor(.blue)
                        .padding(.trailing, 5)
                }
                .padding(.vertical, 0)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat)-> ())-> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: coordinateSpace).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}

#Preview {
    ExploreTesting()
}
