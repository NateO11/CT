//
//  OldVersionsOfScreens.swift
//  CT
//
//  Created by Griffin Harrison on 1/12/24.
//

// Old version of locationDetailView ...  please keep for reference
/* struct LocationDetailView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    let location: Location
    @State private var showingReviewSheet = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        VStack {
            ZStack {
                HStack {
                    /* Button("") {
                    }
                    .buttonStyle(CategoryButton(category: location.category, dimensions: 12))
                    .padding(.trailing, 10)
                    Spacer()
                     */
                    Text(location.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                HStack {
                    
                }
                HStack {
                    Spacer()
                    Button("") {
                        self.presentationMode.wrappedValue.dismiss()
                        // this should dismiss the sheet
                    }
                        .buttonStyle(xButton())
                        .padding(.leading, 10)
                    
                }
            }
            .padding()
                
            
            List(locationViewModel.reviews) { review in
                ReviewView(review: review)
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -20)
            .padding(.top, 20)
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
                .presentationDetents([.medium])
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
 
 */


/* Old review view version ... keep for reference
struct OldReviewView: View {
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


struct NewReviewView: View {
    let review: LocationReview

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
            Text(review.title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
            Text(review.text)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 25)
        .background(Color.clear)
        .padding(.vertical, 5)
    }
}
*/


/*
struct OldWriteReviewView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    @State private var titleText: String = ""
    @State private var reviewText: String = ""
    var onSubmit: (Int, String, String) -> Void

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                    }
                    HStack {
                        Text("Write review")
                            .font(.title
                                .bold())
                    }
                    HStack {
                        Spacer()
                        Button("") {
                            isPresented = false
                        }
                            .buttonStyle(xButton())
                            .shadow(radius: 10)
                        
                    }
                }
                .padding()
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
                TextEditor(text: $titleText)
                    .frame(minHeight: 20)
                    .border(Color.black)
                    .padding()
                
                TextEditor(text: $reviewText)
                    .frame(minHeight: 200)
                    .border(Color.black)
                    .padding()
                   
                
                Button("Submit") {
                    onSubmit(rating + 1, titleText, reviewText)
                    isPresented = false
                }
                .frame(width: 160, height: 60)
                .background(Color.blue.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding()
            }
        }
    }
}
 
 struct HorizontalSchoolsScrollView: View {
     var colleges: [College]

     var body: some View {
         ScrollView(.horizontal, showsIndicators: false) {
             LazyHStack(spacing: 5) {
                 ForEach(colleges, id: \.id) { college in
                     NavigationLink(destination: SchoolView(viewModel: CollegeDetailViewModel(college: college))) {
                         SchoolCard(college: college)
                     }
                 }
             }
             .padding(.horizontal)
             .scrollTargetLayout()
         }
         .scrollTargetBehavior(.viewAligned)
         
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
 
 struct HorizontalSchoolsScrollView: View {
     var colleges: [College]

     var body: some View {
         ScrollView(.horizontal, showsIndicators: false) {
             LazyHStack(spacing: 10) {
                 ForEach(colleges, id: \.id) { college in
                     GeometryReader { geometry in
                         NavigationLink(destination: SchoolView(viewModel: CollegeDetailViewModel(college: college))) {
                             SchoolCard(college: college)
                                 .rotation3DEffect(
                                     .degrees(-Double(geometry.frame(in: .global).minX) / 20),
                                     axis: (x: 0, y: 1, z: 0)
                                 )
                                 .scaleEffect(scaleValue(geometry: geometry))
                         }
                     }
                     .frame(width: 250, height: 300)
                 }
             }
             .padding(.horizontal)
         }
     }

     private func scaleValue(geometry: GeometryProxy) -> CGFloat {
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
 
 
 struct SchoolCard: View {
     let college: College
     var body: some View {
         ZStack {
             RoundedRectangle(cornerRadius: 10)
                 .fill(Color.white)
             VStack(alignment: .leading) {
                 Image(college.image) // Assuming imageName is the name of the image in the assets
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: 200, height: 200)
                     .cornerRadius(20)
                     .clipped()
                     .shadow(radius: 10)
                 
                 VStack(alignment: .leading, spacing: 4) {
                     Text(college.name)
                         .fontWeight(.bold)
                         .font(.title3)
                         .foregroundColor(.black)
                     Text(college.city)
                         .fontWeight(.regular)
                         .font(.caption)
                         .foregroundColor(.black)
                    
                 }
             }
             .padding(30)
         }
     }
 }
 
 //
 //  Explore.swift
 //  CT
 //
 //  Created by Griffin Harrison on 2/1/24.
 //

 import Foundation
 import SwiftUI
 import MapKit


 // this generates the explore page, which is the default page the user visits after logging in ... this is broken down into an unneccessarily large amount of small components but they all get called into the single view at the end ... overall vision for the explore page is for the user to access scroll views as well as a handful of buttons that link to relevant pages (map, search, profile, etc) ... a major inspiration for this UI is the explore page for tripadvisor and how that feels
 struct OldExploreView: View {
     @EnvironmentObject var authState: AuthState
     @ObservedObject var viewModel: ExploreViewModel
     // need to link this up with the authentication logic so the ID and other relevant user data is pulled

     var body: some View {
         NavigationView {
             ScrollView {
                 VStack {
                     TopButtonsSection(userID: authState.currentUserId ?? "4xLrvkubquPQIVNSrUrGCW1Twhi2")
                     // this section contains the welcome message and a number of links to relevant pages, though all are populated with the user profile as of now ... need to eventually make it so the gradient extends all the way to the top
                     
                     LargeImageSection(imageName: "stockimage1", title: "Discover Your Future", description: "Read reviews from current students...")
                     // each large image section will include a stock photo and a link to some feature of the app

                     SchoolScrollView(colleges: viewModel.colleges).environmentObject(authState)
                     // scroll view contains a list of schools that are clickable by the user, navigates to the specific page for that school ... I'm looking to change something within the view model so there could be unique scroll views with unique lists of colleges

                     LargeImageSection(imageName: "stockimage2", title: "Find Your Next Step", description: "Read reviews from current students...")
                     
                     SchoolScrollView(colleges: viewModel.colleges).environmentObject(authState)
                     
                     LargeImageSection(imageName: "stockimage3", title: "I'm going to end it all", description: "The voices are growing louder...")

                     bottomText(text: "Contact us at CollegeTour@gmail.com")
                     // this is just the text at the bottom, meant to make the app more professional ... maybe add in a small "help" link
                 }
                 .onAppear {
                     viewModel.fetchColleges()
                 } // there are some issues with the colleges not loading in with the rest of the componenents, leaving the scroll view blank initially ... I believe there is some udnerlying logic we can change with the async/await stuff to fix this
             }
             .edgesIgnoringSafeArea(.top)
             .navigationBarBackButtonHidden(true)
         }
        .navigationBarBackButtonHidden(true)
     } // navigation being disabled means the user cannot return to the login/signup page which obviously we dont want
 }

 struct ExplorePage_Preview: PreviewProvider {
     static var previews: some View {
         OldExploreView(viewModel: ExploreViewModel()).environmentObject(AuthState.mock)
     }
 }


 */
