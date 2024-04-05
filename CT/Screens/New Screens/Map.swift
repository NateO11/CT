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
//    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.03656936011733, longitude: -78.50271085255682), latitudinalMeters: 1000, longitudinalMeters: 1000))
    // variables used to update which location is currently selected
    
    init(viewModel: MapViewModel, initialSelectedLocation: Location? = nil) {
        self._viewModel = ObservedObject(initialValue: viewModel)
        self._initialSelectedLocation = State(initialValue: initialSelectedLocation)
    }
    
    var body: some View {
        
        Map(selection: $mapSelectionName) {
            ForEach(viewModel.filteredLocations, id: \.id) { location in
                Marker(location.name, systemImage: symbolForCategory(location.category), coordinate: location.coordinate)
                    .tint(colorForCategory(location.category))
            }
        } // creates a marker at each location, using the symbol/color for associated category
        
        .mapStyle(.standard(pointsOfInterest: [])) // sets map style to show no generated locations
        /* .mapControls {
         MapCompass()
         .buttonBorderShape(.circle)
         .padding()
         MapUserLocationButton()
         .buttonBorderShape(.circle)
         .padding()
         } */ // native map buttons to help user orient themselves, kinda useless tho might delete
        
        .overlay(alignment: .bottomTrailing) {
            ExpandedCategorySelect(selectedCategory: $selectedCategory)
                .padding(30)
        } // category modification button, lets user filter types of locations
        .navigationTitle("\(viewModel.college.name) - \(selectedCategory)")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, isPresented: $showSearch)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        
        .onAppear {
            viewModel.fetchLocations()
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
        .sheet(item: $selectedLocation, onDismiss: clearSelection) { location in
            LocationTestingView(viewModel: LocationViewModel(college: viewModel.college, location: location, authState: authState))
                .presentationDetents([.fraction(0.15),.medium,.fraction(0.99)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.4)))
                .ignoresSafeArea()
            
        } // displays small sheet with basic information about location, user can then expand
        
        
        
        .onChange(of: mapSelectionName) { oldValue, newValue in
            if let selected = viewModel.locations.first(where: { $0.id == newValue }) {
                selectedLocation = selected
            } else {
                selectedLocation = nil
            }
        }// deselects location when the sheet info view is closed
    }
    func clearSelection() {
        withAnimation {
            self.selectedLocation = nil
            self.mapSelectionName = nil
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
                                    .frame(width: size.width - 120, height: size.height - 30)
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

