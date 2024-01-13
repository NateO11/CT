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
                    TopButtonsSection(userID: ID) 
                    
                    LargeImageSection(imageName: "stockimage1", title: "Discover Your Future", description: "Read reviews from current students...")

                    SchoolScrollView(colleges: viewModel.colleges)

                    LargeImageSection(imageName: "stockimage2", title: "Find Your Next Step", description: "Read reviews from current students...")
                    
                    SchoolScrollView(colleges: viewModel.colleges)
                    
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
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 90)
                    
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
                    .padding(.bottom, 5) // Adjust spacing as needed
                    
                    // School Information
                    Text(viewModel.college.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.bottom, 10)
                    
                    Text(viewModel.college.city)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    
                    Text(viewModel.college.description)
                        .padding(.bottom, 10)
                    
                    // Navigation Buttons
                    HStack {
                        StyledButtonDark(icon: "mappin", title: "View Map", destination: MapView(viewModel: MapViewModel(college: viewModel.college)))
                    }
                    
                    LocationHorizontalScrollView(title: "Locations", description: "Prominent spots around campus", images: [viewModel.college.image])
                    
                    subTitleText(text: "Categories", subtext: "Hear what students have to say about...")
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 330, height: 250)
                            .foregroundColor(Color.blue.opacity(0.3)) // Adjust the opacity value as needed
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Adjust the shadow properties as needed
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                SubCategoryButton(icon: "g.square", title: "Greek Life", forum: "Greek", viewModel: viewModel)
                                SubCategoryButton(icon: "gear", title: "Engineering", forum: "Engineering", viewModel: viewModel)
                            }
                            HStack {
                                SubCategoryButton(icon: "book", title: "Business", forum: "Business", viewModel: viewModel)
                                SubCategoryButton(icon: "leaf", title: "Dining", forum: "Dining", viewModel: viewModel)
                            }
                            HStack {
                                SubCategoryButton(icon: "football", title: "Athletics", forum: "Athletics", viewModel: viewModel)
                                SubCategoryButton(icon: "pencil", title: "Other", forum: "Other", viewModel: viewModel)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    SchoolCardReviews(college: viewModel.college.name)
                    
                    LocationHorizontalScrollView(title: "Libraries", description: "Read about where students study", images: [viewModel.college.image])
                }
                .padding()
            }
            .ignoresSafeArea()
            .onAppear {
                viewModel.fetchLocations()
            }
        }
        .navigationBarTitle(viewModel.college.name)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
    }
    private func photoScaleValue(geometry: GeometryProxy) -> CGFloat {
            var scale: CGFloat = 1.0
            let offset = geometry.frame(in: .global).minX

            // Adjust these values to control the scale
            let threshold: CGFloat = 100
            if abs(offset) < threshold {
                scale = 1 + (threshold - abs(offset)) / 500
            }

            return scale
        }
     
}

struct subTitleText: View {
    let text: String
    let subtext: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .padding(.top, 40)
                .bold()
            
            Text(subtext)
                .padding(.bottom, 30)

        }
    }
}


struct LocationDetailView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    let location: Location
    @State private var showingReviewSheet = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [colorForCategory(location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
                    .presentationDetents([.fraction(1)])
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled()
            }
    }
}

struct LocationHorizontalScrollView: View {
    let title: String
    let description: String
    let images: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .padding(.top, 40)
                .bold()

            Text(description)
                .padding(.bottom, 30)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 225)
                            .clipped()
                            .cornerRadius(10)
                    }
                }
            }
            .frame(height: 200)
            .padding(.bottom, 10)
        }
    }
}

struct SubCategoryButton: View {
    var icon: String
    var title: String
    var forum: String
    var viewModel: CollegeDetailViewModel // Add this line

    @State private var isLinkActive: Bool = false

    var body: some View {
        NavigationLink(destination: ForumsTemplate(college: viewModel.college.name, forum: forum), isActive: $isLinkActive) {
            Button(action: {
                isLinkActive = true
            }) {
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20) // Set a fixed size for the image

                    Text(title)
                        .foregroundColor(.white)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading) // Allow text to take remaining space
                }
                .padding()
                .background(Color.black)
                .cornerRadius(30)
                .frame(width: 150, height: 60) // Set a fixed size for the entire button
            }
            .buttonStyle(PlainButtonStyle()) // Remove the default button style
        }
    }
}


struct EvenNewerReviewView: View {
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
            LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Image(viewModel.college.image)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
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
                                    EvenNewerReviewView(review: review, firstChar: String(firstChar).uppercased())
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
                .presentationDetents([.fraction(1)])
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
        NavigationStack() {
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
    @StateObject var viewModel: LocationCardViewModel
    @Binding var isPresented: Bool {
        didSet {
            viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationName: viewModel.location.name)
        }
    }
    @State private var rating: Int = 0
    @State private var titleText: String = ""
    @State private var reviewText: String = ""
    var onSubmit: (Int, String, String) -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
                    }
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
                        VStack(alignment: .leading) {
                            Text("Title your review")
                                .font(.headline)
                            TextField("Title", text: $titleText)
                                .border(Color.black)
                            Text("Tell us your thoughts")
                                .font(.headline)
                            TextEditor(text: $reviewText)
                                .border(Color.black)
                        }
                        Button("Submit") {
                            onSubmit(rating + 1, titleText, reviewText)
                            isPresented = false
                        }
                        .frame(width: 160, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(40)
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

struct ForumReviewListView: View {
    var reviews: [(user: String, time: Date, reviewTitle: String, review: String, rating: Int)]

    @State private var expandedReviews: Set<String> = []
    

    var body: some View {
        List {
            ForEach(reviews, id: \.review) { review in
                let firstChar = Array(review.user)[0]
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 25, height: 25)
                            Text(String(firstChar).uppercased())
                                .foregroundStyle(Color.white)
                        }
                        Text("\(review.user)")
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

                    Text("\(review.reviewTitle)")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)

                    Text("\(formattedDate(review.time))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                        .padding(.top, 1)

                    Text(review.review)
                        .lineLimit(expandedReviews.contains(review.user) ? nil : 4) // Show all lines if expanded
                        .font(.body)
                        .foregroundColor(.black)

                    Button(action: {
                        toggleReadMore(review.user)
                    }) {
                        Text(expandedReviews.contains(review.user) ? "Read Less" : "Read More")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top, 5)
                    }
                }
                .padding()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)) // Adjust the bottom inset as needed

            // Add a Spacer view between each VStack
            Spacer().frame(height: 10)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    private func toggleReadMore(_ user: String) {
        if expandedReviews.contains(user) {
            expandedReviews.remove(user)
        } else {
            expandedReviews.insert(user)
        }
    }
}

struct SchoolCardReviews: View {
    var college: String

    var body: some View {
        
        subTitleText(text: "Reviews", subtext: "Where current students voice their opinons")

        
        NavigationLink(destination: ForumsTemplate(college: college, forum: "General")) {
            VStack {
                
                Text("Read Reviews")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20)

                Spacer()
            }
        }
        .navigationBarTitle("")  // To hide the default "Back" button text
        .navigationBarHidden(true) // To hide the navigation bar when transitioning
    }
}



#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
}
