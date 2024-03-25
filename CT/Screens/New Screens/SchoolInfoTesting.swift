//
//  SchoolInfoTesting.swift
//  CT
//
//  Created by Griffin Harrison on 3/24/24.
//

import Foundation
import SwiftUI
import Firebase




struct DisclosureView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(sampleColleges, id: \.city) { college in
                    DisclosureGroup {
                        SchoolScrollView(colleges: sampleColleges).environmentObject(AuthViewModel.mock)
                        
                    } label: {
                        HStack {
                            Text(college.name).font(.title2)
                            Spacer()
                            
                                
                        }//.padding()
                        
                    }.tint(.black).padding()
                }.background(.black.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
            }//.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
        }
        
    }
}


#Preview {
    DisclosureView()
}
