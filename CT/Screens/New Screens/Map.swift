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
    @EnvironmentObject var authState: AuthState
    @ObservedObject var viewModel: MapViewModel
    // view model includes functions to parse location info from firestore

    @State private var showCategorySelect = false
    @State private var selectedCategory = "All" {
        didSet {
            viewModel.updateFilteredLocations(forCategory: selectedCategory)
        }
    }
    var categorySelect: some View {
        CategorySelectView(selectedCategory: $selectedCategory, showCategorySelect: $showCategorySelect)
    }
    // updates location categories when modified
    @State private var initialSelectedLocation: Location? = nil
    @State private var mapSelectionName: String? = nil
    @State private var selectedLocation: Location? = nil
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
            .mapControls {
                MapCompass()
                    .buttonBorderShape(.circle)
                    .padding()
                MapUserLocationButton()
                    .buttonBorderShape(.circle)
                    .padding()
            } // native map buttons to help user orient themselves, kinda useless tho might delete
        
            .overlay(alignment: .bottomTrailing) {
                Button("") {
                    showCategorySelect.toggle()
                }
                .buttonStyle(CategoryButton(category: selectedCategory))
                .padding(30)
                .sheet(isPresented: $showCategorySelect) {
                    categorySelect
                        .presentationDetents([.fraction(0.35)])
                        .presentationDragIndicator(.hidden)
                        .presentationBackground(.ultraThinMaterial)
                        .interactiveDismissDisabled()
                }
            } // category modification button, lets user filter types of locations
            .navigationTitle("\(viewModel.college.name) - \(selectedCategory)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            .onAppear {
                viewModel.fetchLocations()
                if let initialLocation = initialSelectedLocation {
                        // Logic to select initialLocation on the map
                        self.selectedLocation = initialLocation
                        self.mapSelectionName = initialLocation.name
                    }
            } // pulls from firestore on start
            .onChange(of: selectedCategory) { oldCategory, newCategory in
                viewModel.updateFilteredLocations(forCategory: newCategory)
            } // updates locations when they are filtered differently
            .sheet(item: $selectedLocation) { location in
                LocationTestingView(viewModel: LocationViewModel(college: viewModel.college, location: location, authState: authState))
                    .presentationDetents([.fraction(0.15),.medium,.fraction(0.99)])
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.2)))
                    .ignoresSafeArea()
                    
                /* LocationInitialView(viewModel: LocationViewModel(college: viewModel.college, location: location, authState: authState))
                    .presentationDetents([.fraction(0.4)])
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled()
                    .onDisappear(perform: {
                        mapSelectionName = nil
                    }) */
            } // displays small sheet with basic information about location, user can then expand
            
        
        
        .onChange(of: mapSelectionName) { oldValue, newValue in
            if let selected = viewModel.locations.first(where: { $0.name == newValue }) {
                selectedLocation = selected
            } else {
                selectedLocation = nil
            }
        } // deselects location when the sheet info view is closed
    }
}


