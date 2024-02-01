//
//  Explore.swift
//  CT
//
//  Created by Griffin Harrison on 2/1/24.
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
