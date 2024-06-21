//
//  Map.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import MapKit


// view that generates a map for the college based on data pulled from firestore, creating clickable markers at every location which can then be expanded to read more information/reviews

struct MapView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: MapViewModel
    // view model includes functions to parse location info from firestore

    @State private var showCategorySelect = false
    @State private var selectedCategory = "All" {
        didSet {
            viewModel.updateFilteredLocations(forCategory: selectedCategory)
        }
    }
    
    @State private var searchText: String = ""
    @State private var showSearch = false
    @State private var searchResults: [Location] = []
    
    // updates location categories when modified
    @State private var initialSelectedLocation: Location? = nil
    @State private var mapSelectionName: String? = nil
    @State private var selectedLocation: Location? = nil
    @State private var isSheetPresented = false
//    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.03656936011733, longitude: -78.50271085255682), latitudinalMeters: 1000, longitudinalMeters: 1000))
    // variables used to update which location is currently selected
    
    init(viewModel: MapViewModel, initialSelectedLocation: Location? = nil) {
        self._viewModel = ObservedObject(initialValue: viewModel)
        self._initialSelectedLocation = State(initialValue: initialSelectedLocation)
    }
    
    var body: some View {
        
        Map(selection: $mapSelectionName) {
            ForEach(viewModel.filteredLocations, id: \.id) { location in
                //Marker(location.name, systemImage: symbolForCategory(location.category), coordinate: location.coordinate)
                //  .tint(colorForCategory(location.category))
                Annotation(coordinate: location.coordinate, anchor: .bottom) {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .stroke(colorForCategory(location.category), lineWidth: 3)
                                .frame(width: 30, height: 30)
                            Image(systemName: symbolForCategory(location.category))
                                .foregroundStyle(colorForCategory(location.category))
                        }
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(colorForCategory(location.category))
                            .frame(width: 10, height: 10)
                            .rotationEffect(Angle(degrees: 180))
                            .offset(y:-6)
                        
                    }
                    
                    .scaleEffect(location.id == mapSelectionName ? 1.3 : 0.9, anchor: .bottom)
                    .animation(.easeInOut(duration: 0.2), value: mapSelectionName)
                    
                    //.scaleEffect(selectedLocation == location ? 1: 0.7)
                    //.shadow(radius: 10)
                } label: {
                    Text(location.name)
                }
                
                
            }
        } // creates a marker at each location, using the symbol/color for associated category
        
        .mapStyle(.standard(pointsOfInterest: [])) // sets map style to show no generated locations
        .mapControls{
            MapPitchToggle()
                .buttonBorderShape(.circle)
                .padding()
            MapCompass()
                .buttonBorderShape(.circle)
                .padding()
        }
        
        .overlay(alignment: .bottomTrailing) {
            ExpandedCategorySelect(selectedCategory: $selectedCategory)
                .padding(30)
        } // category modification button, lets user filter types of locations
        .navigationTitle("\(viewModel.college.name) - \(selectedCategory)")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, isPresented: $showSearch)
        .autocorrectionDisabled()
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        
        .onAppear {
            if viewModel.locations.isEmpty {
                viewModel.fetchLocations()
            }
            
            if let initialLocation = initialSelectedLocation, selectedLocation == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Giving a slight delay might help in ensuring the view is fully loaded before attempting to present the sheet.
                    self.selectedLocation = initialLocation
                    self.mapSelectionName = initialLocation.id
                    // This forces a re-render, but ensure your logic is sound for setting and using `selectedLocation`.
                }
            }
        }
        // pulls from firestore on start
        .onChange(of: selectedCategory) { oldCategory, newCategory in
            viewModel.updateFilteredLocations(forCategory: newCategory)
        } // updates locations when they are filtered differently
        
        .onChange(of: searchText) { oldCategory, newCategory in
            viewModel.searchLocations(with: searchText)
        }
        .sheet(isPresented: $isSheetPresented, onDismiss: clearSelection) {
            if let location = selectedLocation {
                // LocationTestingView(viewModel: LocationViewModel(college: viewModel.college, location: location, authState: authState))
                AlternateLocationView(viewModel: LocationViewModel(college: viewModel.college, location: location, authState: authState))
                // Your existing modifiers here.
                //.presentationDetents([.fraction(0.35),.medium,.fraction(0.99)])
                    .presentationDetents([.fraction(0.4)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.4)))
                    .presentationDragIndicator(.visible)
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        Button {
                            clearSelection()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 35, height: 35)
                                Image(systemName: "xmark")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .bold()
                            }.padding()
                            
                        }
                    }
                /* .overlay(alignment: .topTrailing) {
                 HStack(spacing: 0) {
                 Menu {
                 Button {
                 openURL(URL(string: "http://maps.apple.com/?q=\(location.name)&ll=\(String(location.coordinate.latitude)),\(String(location.coordinate.longitude))")!)
                 } label: {
                 HStack(spacing: 5) {
                 Image(systemName: "mappin")
                 Text("Open in maps")
                 }.tint(Color("UniversalFG"))
                 }
                 ShareLink(item: URL(string: "https://www.virginia.edu/")!, subject: Text("Download College Tour!"), message: Text("Check out this spot at \(viewModel.college.name) in College Tour!")) {
                 Label("Share", systemImage: "square.and.arrow.up")
                 }
                 
                 } label: {
                 Image(systemName: "ellipsis.circle")
                 .resizable()
                 .scaledToFit()
                 .foregroundStyle(Color("UniversalFG"))
                 .frame(width: 30, height: 30)
                 .padding(.trailing, 15)
                 .padding(.top, 25)
                 }
                 
                 Button {
                 clearSelection()
                 } label: {
                 Image(systemName: "xmark.circle")
                 .resizable()
                 .scaledToFit()
                 .foregroundStyle(Color("UniversalFG"))
                 .frame(width: 30, height: 30)
                 .padding(.trailing, 15)
                 .padding(.top, 25)
                 }
                 }
                 
                 } */
                
            }
            
        } // displays small sheet with basic information about location, user can then expand
        
        
        .onChange(of: mapSelectionName) { oldValue, newValue in
            print("values have changed")
            
            if let newLocation = viewModel.locations.first(where: { $0.id == newValue }) {
                
                withAnimation {
                    selectedLocation = newLocation
                    isSheetPresented = true
                    
                }
            } else {
                selectedLocation = nil
                isSheetPresented = false
            }
            
        }
    
// deselects location when the sheet info view is closed
    }
    func clearSelection() {
        withAnimation {
            selectedLocation = nil
            mapSelectionName = nil
        }
        
    }
    
    

}


struct MapSchoolView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: ExploreViewModel
    @State private var selectedSchool: College? = nil
    @State private var initialSelectedSchool: College? = nil
    @State private var selectedSchoolName: String? = nil
    var schools: [College]
    var body: some View {
        Map(selection: $selectedSchoolName) {
            ForEach(schools, id: \.id) { school in
                Marker(school.name, systemImage: "building.columns.fill", coordinate: school.coordinate)
                    .tint(school.color)
            }
        }
        
        .mapStyle(.standard(pointsOfInterest: []))
        .overlay(alignment: .bottom) {
            MapSchoolScrollView(colleges: schools, selectedSchoolName: $selectedSchoolName).environmentObject(authState)
        }
        .navigationTitle("Schools")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .onChange(of: selectedSchoolName) { oldValue, newValue in
            print(newValue)
        }
        
    }
}


struct MapSchoolScrollView: View {
    @EnvironmentObject var authState: AuthViewModel
    var colleges: [College]
    @Binding var selectedSchoolName: String?
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            ScrollViewReader { scrollViewReader in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 5) {
                        ForEach(colleges) { college in
                            if college.available {
                                NavigationLink(destination: SchoolView(viewModel: MapViewModel(college: college)).environmentObject(authState)) {
                                    GeometryReader(content: { proxy in
                                        let cardSize = proxy.size
                                        let minX = proxy.frame(in: .scrollView).minX - 60
                                        
                                        Image(college.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .offset(x: -minX)
                                            .frame(width: proxy.size.width * 1.5)
                                            .frame(width: cardSize.width, height: cardSize.height)
                                            .overlay {
                                                AvailableOverlayNoStar(college: college)
                                                
                                            }
                                            .clipShape(.rect(cornerRadius: 15))
                                            .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                        
                                    })
                                    .frame(width: size.width - 120, height: size.height - 10)
                                    .scrollTransition(.interactive, axis: .horizontal) {
                                        view, phase in
                                        view
                                            .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                    }
                                }
                            } else {
                                NavigationLink(destination: EditProfileView()) {
                                    GeometryReader(content: { proxy in
                                        let cardSize = proxy.size
                                        let minX = proxy.frame(in: .scrollView).minX - 60
                                        
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
                                            .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                    }
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal, 60)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .top)
                    
                }
                .scrollDisabled(true)
                .scrollPosition(id: $selectedSchoolName)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                .onChange(of: selectedSchoolName) { oldValue, newValue in
                    print(newValue)
                    if let newValue = newValue, let targetIndex = colleges.firstIndex(where: { $0.name == newValue }) {
                                            // Animate the scrolling to the new school
                                            withAnimation {
                                                scrollViewReader.scrollTo(colleges[targetIndex].id, anchor: .leading)
                                            }
                                        }
                }
            
            }
                
        })
        .frame(height: 200)
        .padding(.horizontal, -15)
        .padding(.top, 20)
    }
}



struct NewMapViewAllSchools: View {
    
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: ExploreViewModel
    @State private var initialSelectedLocation: College? = nil
    @State private var selectedSchool: College? = nil
    @State private var selectedSchoolName: String? = nil
    @State private var isSheetPresented = false
    
    init(viewModel: ExploreViewModel, initialSelectedLocation: College? = nil) {
        self._viewModel = ObservedObject(initialValue: viewModel)
        self._initialSelectedLocation = State(initialValue: initialSelectedLocation)
    }

    var body: some View {
        
        Map(selection: $selectedSchoolName) {
            ForEach(viewModel.colleges, id: \.id) { school in
                Annotation(coordinate: school.coordinate, anchor: .bottom) {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .stroke(school.color, lineWidth: 3)
                                .frame(width: 30, height: 30)
                            Image(systemName: "building.columns.fill")
                                .foregroundStyle(school.color)
                        }
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(school.color)
                            .frame(width: 10, height: 10)
                            .rotationEffect(Angle(degrees: 180))
                            .offset(y:-6)
                        
                    }
                    
                    .scaleEffect(school.id == selectedSchoolName ? 1.3 : 0.9, anchor: .bottom)
                    .animation(.easeInOut(duration: 0.2), value: selectedSchoolName)
                    
                    //.scaleEffect(selectedLocation == location ? 1: 0.7)
                    //.shadow(radius: 10)
                } label: {
                    Text(school.name)
                }
            }
        }
        
        .mapStyle(.standard(pointsOfInterest: []))
        
        .onAppear {
            if viewModel.colleges.isEmpty {
                viewModel.fetchColleges()
            }
            
            if let initialLocation = initialSelectedLocation, selectedSchool == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.selectedSchool = initialLocation
                    self.selectedSchoolName = initialLocation.id
                }
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        
        .sheet(isPresented: $isSheetPresented, onDismiss: clearSelection) {
            if let college = selectedSchool {
                // LocationTestingView(viewModel: LocationViewModel(college: viewModel.college, location: location, authState: authState))
                SchoolPopUpView(college: college).environmentObject(authState)
                // Your existing modifiers here.
                //.presentationDetents([.fraction(0.35),.medium,.fraction(0.99)])
                    .presentationDetents([.fraction(0.4)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.4)))
                    .presentationDragIndicator(.visible)
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        Button {
                            clearSelection()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 35, height: 35)
                                Image(systemName: "xmark")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .bold()
                            }.padding()
                            
                        }
                    }
            
            }
        }
        .onChange(of: selectedSchoolName) { oldValue, newValue in
            
            if let newLocation = viewModel.colleges.first(where: { $0.id == newValue }) {
                
                withAnimation {
                    selectedSchool = newLocation
                    isSheetPresented = true
                    
                }
                print(selectedSchool?.name)
            } else {
                selectedSchool = nil
                isSheetPresented = false
            }

        }
        
    }
    func clearSelection() {
        withAnimation {
            selectedSchool = nil
            selectedSchoolName = nil
        }
        
    }
    
}


struct SchoolPopUpView: View {
    @EnvironmentObject var authState: AuthViewModel
    var college: College

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Background Image
                AsyncImage(url: URL(string: "https://news.virginia.edu/sites/default/files/Header_SF_AldermanRenaming_TomDaly.jpg")) { image in
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
                    Text(college.city)
                        .font(.callout)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        
                    
                    Text(college.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    NavigationLink(destination: NewSchoolView(viewModel: MapViewModel(college: college)).environmentObject(authState)) {
                        Text("Explore")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .bold()
                            .padding()
                            .frame(width: geometry.size.width * 0.6)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                }
                .padding()
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
