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
    @State private var bookmarks = Bookmarks()
    
    @State var searchText: String = ""
    @FocusState var isInputActive: Bool
    
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
                                SchoolScrollView(colleges: viewModel.colleges, titleText: "Virginia schools").environmentObject(authState)
                                //
                                LargeImageSection(imageName: "stockimage5", title: "Find your new home", description: "Read reviews from students just like yourself", buttonText: "View Schools", destination: SchoolListView(viewModel: viewModel).environmentObject(authState))
                                LargeImageSection(imageName: "stockimage3", title: "Our purpose", description: "We want to help you learn about colleges", buttonText: "About Us", destination: AboutUs())

                                Text("Contact us at CollegeTourApp@gmail.com")
                                    .font(.caption2)
                                    .fontWeight(.thin)
                                    .padding(.top, 10)
                            }
                            .zIndex(0)
                        } else {
                            
                            SearchResultsTestView(viewModel: viewModel, query: $searchText).environmentObject(authState)
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
        }.environmentObject(bookmarks)
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
                            isInputActive = false
                        }
                    TextField("Search", text: $searchText)
                        .keyboardType(.asciiCapable)
                        .foregroundStyle(.white)
                        .focused($isInputActive)
                        .autocorrectionDisabled(true)
                        
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isInputActive = false
                                }
                            }
                        }
                    
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
                // NavigationLink(destination: EditProfileView()) {
                //NavigationLink(destination: MapSchoolView(viewModel: viewModel, schools: viewModel.colleges).environmentObject(authState)) {
                NavigationLink(destination: NewMapViewAllSchools(viewModel: viewModel ).environmentObject(authState)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.gradient)
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
                
                NavigationLink(destination: BookmarksView(viewModel: viewModel).environmentObject(bookmarks).environmentObject(authState)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.gradient)
                            .shadow(radius: 10)
                        HStack(spacing: 0) {
                            Image(systemName: "bookmark.fill")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .shadow(radius: 10)
                                .frame(width: 40, height: 40)
                            Text("Saved")
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


struct SearchResultsTestView: View {
    @EnvironmentObject var authState: AuthViewModel
    var viewModel: ExploreViewModel // Make sure this matches the type of your viewModel
    @Binding var query: String

    var body: some View {
        if !query.isEmpty {
            let searchResults = viewModel.searchColleges(with: query)
            ForEach(searchResults) { college in
                
                if college.available {
                    NavigationLink(destination: NewSchoolView(viewModel: MapViewModel(college: college)).environmentObject(authState)) {
                        
                        GroupBox {
                            HStack {
                                Image(college.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(college.id)
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    Text(college.city)
                                        .font(.subheadline)
                                        .fontWeight(.light)
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                                .padding(.leading, 5)
                                Spacer()
                            }
                        }.backgroundStyle(Color("UniversalBG").gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal, 20)
                        
                    }.tint(.primary)
                } else {
                    NavigationLink(destination: EditProfileView()) {
                        GroupBox {
                            HStack {
                                Image(college.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(college.id)
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    Text(college.city)
                                        .font(.subheadline)
                                        .fontWeight(.light)
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                                .padding(.leading, 5)
                                Spacer()
                            }
                        }.backgroundStyle(Color("UniversalBG").gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal, 20)
                    }.tint(.primary)
                }
                
            }
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


struct BookmarksView: View {
    @EnvironmentObject var bookmarks: Bookmarks
    @ObservedObject var viewModel: ExploreViewModel
    @EnvironmentObject var authState: AuthViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Saved locations")
                        .font(.largeTitle).padding(.horizontal, 18).fontWeight(.bold).padding(.top, 10)
                    if bookmarks.getBookmarks().isEmpty {
                        HStack {
                            Spacer()
                            Text("Go bookmark some locations!")
                            Spacer()
                        }.padding(.top, 20)
                    } else {
                        ForEach(bookmarks.getBookmarks(), id: \.id) { bookmark in
                            if let college = viewModel.colleges.first(where: { $0.name == bookmark.schoolName }) {
                                NavigationLink(destination: MapView(viewModel: MapViewModel(college: college), initialSelectedLocation: bookmark.id).environmentObject(authState)) {
                                    GroupBox {
                                        HStack {
                                            AsyncImage(url: URL(string: bookmark.locationImageURL)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            } placeholder: {
                                                Color.black
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(String(bookmark.name))
                                                    .multilineTextAlignment(.leading)
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                
                                                
                                                
                                                Text(bookmark.schoolName)
                                                    .font(.subheadline)
                                                    .fontWeight(.light)
                                                    .foregroundStyle(.primary.opacity(0.8))
                                                
                                            }
                                            .padding(.leading, 5)
                                            Spacer()
                                        }
                                    }.backgroundStyle(Color("UniversalBG").gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .padding(.horizontal, 20)
                                    
                                }.tint(.primary)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}


struct SchoolListView: View {
    @EnvironmentObject var authState: AuthViewModel
    var viewModel: ExploreViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("All Schools")
                    .font(.largeTitle).padding(.horizontal, 18).fontWeight(.bold).padding(.top, 10)
                ForEach(viewModel.colleges) { college in
                    
                    if college.available {
                        NavigationLink(destination: NewSchoolView(viewModel: MapViewModel(college: college)).environmentObject(authState)) {
                            
                            GroupBox {
                                HStack {
                                    Image(college.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(college.id)
                                            .multilineTextAlignment(.leading)
                                            .font(.title3)
                                            .fontWeight(.semibold)

                                        Text(college.city)
                                            .font(.subheadline)
                                            .fontWeight(.light)
                                            .foregroundStyle(.primary.opacity(0.8))
                                    }
                                    .padding(.leading, 5)
                                    Spacer()
                                }
                            }.backgroundStyle(Color("UniversalBG").gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.horizontal, 20)
                            
                        }.tint(.primary)
                    } else {
                        NavigationLink(destination: EditProfileView()) {
                            GroupBox {
                                HStack {
                                    Image(college.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(college.id)
                                            .multilineTextAlignment(.leading)
                                            .font(.title3)
                                            .fontWeight(.semibold)

                                        Text(college.city)
                                            .font(.subheadline)
                                            .fontWeight(.light)
                                            .foregroundStyle(.primary.opacity(0.8))
                                    }
                                    .padding(.leading, 5)
                                    Spacer()
                                }
                            }.backgroundStyle(Color("UniversalBG").gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.horizontal, 20)
                        }.tint(.primary)
                    }
                    
                }
            }
        }
    }
}


struct LargeImageSection<Destination: View>: View {
    let imageName: String
    let title: String
    let description: String
    let buttonText: String
    let destination: Destination

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
                HStack(spacing: 5) {
                    Text(description)
                        .font(.headline)
                        .foregroundColor(.white)
               
                        Spacer()
                        NavigationLink(destination: destination) {
                            Text(buttonText)
                                .foregroundColor(.black)
                                .padding()
                                .bold()
                                .background(Color.white.gradient)
                                .cornerRadius(30)
                        }
                    
                }
            }
            .padding()
        }
        .clipShape(.rect(bottomLeadingRadius: 10, bottomTrailingRadius: 10))
        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
    }
}
