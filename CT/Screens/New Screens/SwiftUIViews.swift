//
//  SwiftUIViews.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit

struct ExploreView: View {
    @ObservedObject var viewModel: ExploreViewModel
    var ID: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TopButtonsSection(userID: ID) // Pass the actual user ID

                    LargeImageSection(imageName: "stockimage1", title: "Discover Your Future", description: "Read reviews from current students...")

                    HorizontalSchoolsScrollView(colleges: viewModel.colleges)

                    LargeImageSection(imageName: "stockimage2", title: "Find Your Next Step", description: "Read reviews from current students...")
                    
                    HorizontalSchoolsScrollView(colleges: viewModel.colleges)
                    
                    LargeImageSection(imageName: "stockimage3", title: "I'm going to end it all", description: "The voices are growing louder...")

                    bottomText(text: "Contact us at CollegeTour@gmail.com")
                }
                .onAppear {
                    viewModel.fetchColleges()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
       .navigationBarBackButtonHidden(true)
    }
}


struct SchoolView: View {
    @ObservedObject var viewModel: CollegeDetailViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    // Horizontal Scroll of Photos
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(1..<5) { _ in
                                Image(viewModel.college.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 200)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .frame(height: 200)

                    // School Information
                    Text(viewModel.college.name)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        

                    Text(viewModel.college.city)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)

                    Text(viewModel.college.description)
                        .padding(.bottom, 10)

                    // Reviews Section
                    // Assuming you have a View for displaying reviews
                    // ReviewsView(reviews: viewModel.reviews)

                    // Navigation Buttons
                    HStack(alignment: .top) {
                        StyledButtonDark(icon: "mappin", title: "Locations", destination: MapView(viewModel: MapViewModel(currentCollegeName: viewModel.college.name)))
                        StyledButtonDark(icon: "mappin", title: "Locations", destination: MapView(viewModel: MapViewModel(currentCollegeName: viewModel.college.name)))
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchLocations()
        }
        }
    }
}

struct CollegeInfoView: View {
    let college: College

    var body: some View {
        VStack(alignment: .leading) {
            Text(college.name).font(.title)
            // Other college details
        }
    }
}

struct LocationDetailView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    let location: Location
    @State private var showingReviewSheet = false

    var body: some View {
        VStack {
            // Location details
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(.white)
            
            Text(location.category)
                .font(.title2)
                .fontWeight(.medium)
                .padding(.top, 10)
                .foregroundColor(.white)
            
            List(locationViewModel.reviews) { review in
                ReviewView(review: review)
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -20)
            Button("Write a Review") {
                showingReviewSheet = true
            }
            .frame(width: 160, height: 60)
            .background(Color.blue.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding()
            .sheet(isPresented: $showingReviewSheet) {
                WriteReviewView(isPresented: $showingReviewSheet) { rating, text in
                    locationViewModel.submitReview(rating: rating, text: text, forLocation: location.id)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .opacity(0.8)
        )
        .onAppear {
            locationViewModel.fetchReviews(forLocation: location.id)
        }
    }
}

struct ReviewView: View {
    let review: Review

    var body: some View {
        // Layout for displaying the review
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(review.userID)")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text("\(review.rating) stars")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
            }
            Text(review.text)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding(10)
        .background(Color.clear)
        .padding(.vertical, 5)
    }
}

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel

    @State private var showCategorySelect = false
    @State private var selectedCategory = "All" {
            didSet {
                viewModel.updateFilteredLocations(forCategory: selectedCategory)
            }
        }
    @State private var mapSelectionName: String? = nil
    @State private var selectedLocation: Location? = nil
    @State private var showReviews: Bool = false
    var categorySelect: some View {
        CategorySelectView(selectedCategory: $selectedCategory, showCategorySelect: $showCategorySelect)
    }
    
    
    var body: some View {
        NavigationStack() {
            Map(initialPosition: defaultPosition, selection: $mapSelectionName) {
                ForEach(viewModel.filteredLocations, id: \.id) { location in
                    Marker(location.name, systemImage: symbolForCategory(location.category), coordinate: location.coordinate)
                        .tint(colorForCategory(location.category))
                }
            }
            .mapStyle(.standard(pointsOfInterest: []))
            .mapControls {
                MapCompass()
                    .buttonBorderShape(.circle)
                    .padding()
                MapUserLocationButton()
                    .buttonBorderShape(.circle)
                    .padding()
            }
            .overlay(alignment: .bottomTrailing) {
                Button("") {
                    showCategorySelect.toggle()
                }
                .buttonStyle(CategoryButton(category: selectedCategory))
                .padding(30)
                .sheet(isPresented: $showCategorySelect) {
                    categorySelect
                        .presentationDetents([.fraction(0.25)])
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(25)
                }
            }
            .navigationTitle("\(viewModel.currentCollegeName) - \(selectedCategory)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            .onAppear {
                viewModel.fetchLocations()
        }
            .onChange(of: selectedCategory) { oldCategory, newCategory in
                        viewModel.updateFilteredLocations(forCategory: newCategory)
                    }
            // ... rest of your view
            .sheet(item: $selectedLocation) { location in
                LocationDetailView(locationViewModel: LocationViewModel(), location: location)
                    .presentationDetents([.medium, .large])
            }
            
        }
        
        .onChange(of: mapSelectionName) { oldValue, newValue in
            if let selected = viewModel.locations.first(where: { $0.name == newValue }) {
                selectedLocation = selected
            } else {
                selectedLocation = nil
            }
        }
    }
}



// Map annotation view goes here (if using MapKit)

struct WriteReviewView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    var onSubmit: (Int, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Picker("Rating", selection: $rating) {
                    ForEach(1...5, id: \.self) {
                        Text("\($0) Stars")
                    }
                }
                TextEditor(text: $reviewText)
                    .frame(minHeight: 200)
            }
            .navigationTitle("Write Review")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Submit") {
                onSubmit(rating, reviewText)
                isPresented = false
            })
        }
    }
}


#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
}
