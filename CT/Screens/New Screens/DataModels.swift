//
//  DataModels.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseFirestore


struct College: Identifiable {
    let id: String
    let available: Bool
    let name: String
    let city: String
    let description: String
    let image: String
}

struct Location: Identifiable {
    let id: String
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let category: String
}


struct Review {
    let text: String
    let rating: Int
    let userID: String
    let title: String
    let timestamp: Date
}

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let fullname: String
    
    var intitals: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
