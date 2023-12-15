//
//  SchoolViewer.swift
//  CT
//
//  Created by Nate Owen on 12/14/23.
//

import SwiftUI

struct SchoolViewer: View {
    
    // from SchoolSelect
    var selectedSchool: School?

    var body: some View {
        VStack {
            if let school = selectedSchool {
                Image(school.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(8)
                
                Text(school.name)
                    .font(.title)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct SchoolViewer_Previews: PreviewProvider {
    static var previews: some View {
        SchoolViewer(selectedSchool: schools.first)
    }
}
