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
    let coordinate: CLLocationCoordinate2D
    let color: Color
}

struct Location: Identifiable {
    let id: String
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let category: String
    let imageLink: String
}

struct SchoolInfo {
    let category: String
    let stats: [Int]
    let classification: String
    let statDescriptions: [String]
    let description: String
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
    var favorites: [String] = []
    
    var intitals: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
