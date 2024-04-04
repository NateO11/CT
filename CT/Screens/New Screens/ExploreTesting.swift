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


struct ExploreView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: ExploreViewModel
    
    @State var searchText: String = ""
    
    @State var offsetY: CGFloat = 0
    //@State var showSearch: Bool = false
    var body: some View {
        NavigationStack {
            GeometryReader{proxy in
                let safeAreaTop = proxy.safeAreaInsets.top
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HeaderView(safeAreaTop)
                            .offset(y: -offsetY)
                            .zIndex(1)
                        
                        if searchText == "" {
                            
                            VStack {
                                // I want this first Hstack to be reserved for favorites
                                SchoolScrollView(colleges: viewModel.colleges, titleText: "Favorite schools").environmentObject(authState)
                                //
                                LargeImageSection(imageName: "stockimage5", title: "Find your new home", description: "Read reviews from students just like yourself...")
                                SchoolScrollView(colleges: viewModel.colleges, titleText: "Featured schools").environmentObject(authState)
                                LargeImageSection(imageName: "stockimage3", title: "Discover Colleges That Fit You Best", description: "Use our maps to explore campuses")
                                SchoolScrollView(colleges: viewModel.colleges, titleText: "Local schools").environmentObject(authState)
                                LargeImageSection(imageName: "stockimage2", title: "What's your next step? ", description: "Learn about more schools near you")
                                Text("Contact us at CollegeTour@gmail.com")
                                    .font(.caption2)
                                    .fontWeight(.thin)
                                    .padding(.top, 10)
                            }
                            .zIndex(0)
                        } else {
                            SearchResultsView(searchText).environmentObject(authState).zIndex(0)
                            // SearchResultsViewTest(viewModel: viewModel, query: searchText)
                        }

                    }
                    .offset(coordinateSpace: .named("SCROLL")) { offset in
                        offsetY = offset
                        //showSearch = (-offset > 80) && showSearch
                    }
                    .onAppear {
                        viewModel.fetchColleges()
                    }
                }
                .coordinateSpace(name: "SCROLL")
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
    
    @ViewBuilder
    func SearchResultsView(_ query: String) -> some View {
        if !query.isEmpty {
            let searchResults = viewModel.searchColleges(with: query)
            ForEach(searchResults) { college in
                NavigationLink(destination: SchoolView(viewModel: MapViewModel(college: college)).environmentObject(authState)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(college.name)
                                .multilineTextAlignment(.leading)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(college.city)
                                .font(.caption)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title)
                    }.tint(.black).padding(20)
                }.background(.black.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)).padding(.horizontal, 10)
            }
        }
    }

    
    
    @ViewBuilder
    func HeaderView(_ safeAreaTop: CGFloat)-> some View {
        let progress = -(offsetY / 80) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                HStack(spacing: 8) {
                    Image(systemName: searchText.isEmpty ? "magnifyingglass" : "xmark")
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundColor(.white)
                        .onTapGesture {
                            searchText = ""
                        }
                    TextField("Search", text: $searchText)
                        .foregroundStyle(.white)
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.white)
                        .opacity(0.25)
                }
                .opacity( 1+progress)
                
                NavigationLink(destination: ProfilePage().environmentObject(authState)) {
                    Text(authState.currentUser?.intitals ?? "DU")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 40,height: 40)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }

                }
                

            }
            HStack(spacing: 15) {
                NavigationLink(destination: MapSchoolView(viewModel: viewModel, schools: viewModel.colleges).environmentObject(authState)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .shadow(radius: 10)
                        HStack(spacing: 0) {
                            Image(systemName: "map.fill")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .shadow(radius: 10)
                                .frame(width: 40, height: 40)
                            Text("Schools")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .foregroundColor(.blue)
                                .shadow(radius: 10)
                                .padding(.trailing, 5)
                        }
                        .padding(.vertical, 0)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                NavigationLink(destination: EditProfileView().environmentObject(authState)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .shadow(radius: 10)
                        HStack(spacing: 0) {
                            Image(systemName: "star.fill")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .shadow(radius: 10)
                                .frame(width: 40, height: 40)
                            Text("Favorites")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .foregroundColor(.blue)
                                .shadow(radius: 10)
                                .padding(.trailing, 5)
                        }
                        .padding(.vertical, 0)
                    }
                    .frame(maxWidth: .infinity)
                }
                
            }
            .padding(.horizontal, -progress*35)
            .padding(.vertical, 10)
            .offset(x: progress*25, y:progress*65)
            
        }

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
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .shadow(radius: 10)
                HStack(spacing: 0) {
                    Image(systemName: symbolImage)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .shadow(radius: 10)
                        .frame(width: 40, height: 40)
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .foregroundColor(.blue)
                        .shadow(radius: 10)
                        .padding(.trailing, 5)
                }
                .padding(.vertical, 0)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct SearchResultsViewTest: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: ExploreViewModel
    @State var query: String
    @State var searchResults: [College]
    
    init(viewModel: ExploreViewModel, query: String) {
        self.viewModel = viewModel
        self.query = query
        self.searchResults = viewModel.searchColleges(with: query)
    }
    
    
    var body: some View {
        ForEach(searchResults) { college in
            NavigationLink(destination: SchoolView(viewModel: MapViewModel(college: college)).environmentObject(authState)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(college.name)
                            .multilineTextAlignment(.leading)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(college.city)
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title)
                }.tint(.black).padding(20)
            }.background(.black.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)).padding(.horizontal, 10)
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

struct ExploreTesting_Preview: PreviewProvider {
    static var previews: some View {
        ExploreView(viewModel: ExploreViewModel()).environmentObject(AuthViewModel.mock)
    }
}
