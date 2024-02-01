//
//  SwiftUIViews.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit


struct LocationDetailView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    let location: Location
    @State private var showingReviewSheet = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [colorForCategory(location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                HStack {
                    VStack {
                        Image(locationViewModel.college.image) // Assuming imageName is the name of the image in the assets
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .cornerRadius(20)
                            .clipped()
                            .padding()
                    }
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                            VStack {
                                Text(location.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 5)
                                Text("\(location.name) is a super cool place at \(locationViewModel.college.name)")
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10)
                                Button("Read Reviews!") {
                                    showingReviewSheet = true
                                }
                                .frame(width: 160, height: 60)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .shadow(radius: 10)
                                .padding(10)
                                }
                            }
                        
                        .padding([.vertical], 30)
                    .padding(.trailing, 20)
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button("") {
                    self.presentationMode.wrappedValue.dismiss()
                    // this should dismiss the sheet
                }
                .buttonStyle(xButton())
                .shadow(radius: 10)
                .padding(10)
        
        }
            .sheet(isPresented: $showingReviewSheet) {
                // This is the sheet presentation
                LocationCardView(viewModel: LocationCardViewModel(college: locationViewModel.college, location: location))
                    .presentationDetents([.fraction(0.99)])
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled()
            }
    }
}



struct ReviewView: View {
    let review: LocationReview
    let firstChar: String
    @State private var expandedReviews: Set<String> = []
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 25, height: 25)
                    Text(String(firstChar).uppercased())
                        .foregroundStyle(Color.white)
                }
                Text("\(review.userID)")
                    .font(.subheadline)
                    .foregroundColor(.black)

            }
            
            HStack {
                ForEach(0..<review.rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                ForEach(review.rating..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 1)

            Text("\(review.title)")
                .font(.headline)
                .bold()
                .foregroundColor(.black)

            Text("\(formattedDate(review.timestamp))")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
                .padding(.top, 1)

            Text(review.text)
                .lineLimit(expandedReviews.contains(review.userID) ? nil : 4) // Show all lines if expanded
                .font(.body)
                .foregroundColor(.black)

        }
        .padding()
    }
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct LocationCardView: View {
    @StateObject var viewModel: LocationCardViewModel
    @State private var showingWriteReviewSheet = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            VStack {
                Image(viewModel.college.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 150)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.top, 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .frame(height: 100)
                    VStack(alignment: .leading, spacing: 8) {
                        VStack{
                            Text(viewModel.location.name)
                                .font(.title)
                                .multilineTextAlignment(.center)
                            Text(viewModel.college.name)
                                .font(.headline)
                        }
                        .padding()
                        
                    }
                    .padding(.horizontal, 40)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .frame(maxHeight: .infinity)
                    VStack {
                        if viewModel.reviews.isEmpty {
                            Text("Be the first to review this location")
                        } else {
                            List {
                                ForEach(viewModel.reviews, id: \.text) { review in
                                    let firstChar = Array(review.userID)[0]
                                    ReviewView(review: review, firstChar: String(firstChar).uppercased())
                                }
                            }.scrollContentBackground(.hidden).padding(.top, -20)
                            Spacer()
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationName: viewModel.location.name)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button("") {
                self.presentationMode.wrappedValue.dismiss()
                // this should dismiss the sheet
            }
            .buttonStyle(xButton())
            .shadow(radius: 10)
            .padding(10)
        }
        .overlay(alignment: .bottom) {
            Button("Write a Review") {
                showingWriteReviewSheet = true
            }
            .frame(width: 160, height: 60)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(40)
            .shadow(radius: 10)
            .padding()
            .sheet(isPresented: $showingWriteReviewSheet) {
                WriteReviewView(viewModel: LocationCardViewModel(college: viewModel.college, location: viewModel.location), isPresented: $showingWriteReviewSheet) { rating, title, text in
                    viewModel.submitReview(rating: rating, title: title, text: text, forLocation: viewModel.location.id)
                }
                .presentationDetents([.fraction(0.99)])
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
            
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
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

            Map(selection: $mapSelectionName) {
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
                        .presentationDetents([.fraction(0.35)])
                        .presentationDragIndicator(.hidden)
                        .presentationBackground(.ultraThinMaterial)
                        .interactiveDismissDisabled()
                }
            }
            .navigationTitle("\(viewModel.college.name) - \(selectedCategory)")
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
                LocationDetailView(locationViewModel: LocationViewModel(college: viewModel.college), location: location)
                    .presentationDetents([.fraction(0.4)])
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled()
                    .onDisappear(perform: {
                        mapSelectionName = nil
                    })
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


struct WriteReviewView: View {
    @StateObject var viewModel: LocationCardViewModel
    @Binding var isPresented: Bool {
        didSet {
            viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationName: viewModel.location.name)
        }
    }
    @State private var rating: Int = 0
    @State private var titleText: String = ""
    @State private var reviewText: String = ""
    @State private var showAlert: Bool = false
    var onSubmit: (Int, String, String) -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .frame(height: 100)
                    HStack {
                        Image(viewModel.college.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(10)
                        VStack(alignment: .leading) {
                            Text(viewModel.location.name)
                                .font(.title)
                            Text("\(viewModel.college.name) - \(viewModel.college.city)")
                                .font(.headline)
                        }
                    }.padding(.horizontal, 25)
                }
                .padding(.top, 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                    VStack {
                        HStack {
                            ForEach(0..<5) {value in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 30,height: 30)
                                    .foregroundColor(self.rating >= value ? .yellow : .gray)
                                    .onTapGesture {
                                        self.rating = value
                                    }
                            }
                        }
                        .padding(.bottom, 10)
                        VStack(alignment: .leading) {
                            Text("Title your review")
                                .font(.headline)
                            TextField("Title", text: $titleText)
                                .padding(5)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                            Text("Write your review")
                                .font(.headline)
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $reviewText)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                if reviewText == "" {
                                    Text("Tell us what you think!")
                                        .foregroundStyle(Color.gray.opacity(0.6))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                }
                            }
                        }
                        Button("Submit") {
                            if titleText != "" && reviewText != "" {
                                onSubmit(rating + 1, titleText, reviewText)
                                isPresented = false
                            } else {
                                showAlert = true
                            }
                        }.alert("Must fill out all fields! \nGet a clue lil bro", isPresented: $showAlert, actions: {})
                        .frame(width: 160, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                        .padding()
                    }
                    .padding(30)
                    
                }
                Spacer()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button("") {
                isPresented = false
                // this should dismiss the sheet
            }
            .buttonStyle(xButton())
            .shadow(radius: 10)
            .padding(10)
        }
    }
}


struct SearchView: View {
    var colleges: [College]
    
    var body: some View {
            VStack{
                Text("All Schools")
                    .font(.largeTitle)
                
                
                List(colleges) { college in
                    NavigationLink(destination: SchoolView(viewModel: CollegeDetailViewModel(college: college))) {
                        HStack {
                            Image(college.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75)
                                .cornerRadius(40)
                                .shadow(radius: 15)
                            
                            VStack(alignment: .leading) {
                                Text(college.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(college.city)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                //   .navigationBarTitle("Virginia Schools")
                
            
        }
    }
}



#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
}
