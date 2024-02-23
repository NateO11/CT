//
//  OnboardingView.swift
//  CT
//
//  Created by Griffin Harrison on 2/21/24.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseFirestore
import CoreLocation



struct onboardingView: View {
    var userType = ["Prospective Student", "College Student", "Parent"]
    @State var show = false
    @State var selected = "Prospective Student"
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                ScrollView {
                    VStack(spacing: 17) {
                        ForEach(userType, id: \.self) { userType in
                            Text(userType)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    onboardingView()
}
