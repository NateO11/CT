//
//  SearchPageView.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import MapKit



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
