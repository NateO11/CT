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
struct ExploreView: View {
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

                    SchoolScrollView(colleges: viewModel.colleges)
                    // scroll view contains a list of schools that are clickable by the user, navigates to the specific page for that school ... I'm looking to change something within the view model so there could be unique scroll views with unique lists of colleges

                    LargeImageSection(imageName: "stockimage2", title: "Find Your Next Step", description: "Read reviews from current students...")
                    
                    SchoolScrollView(colleges: viewModel.colleges)
                    
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
        ExploreView(viewModel: ExploreViewModel()).environmentObject(AuthState.mock)
    }
}
