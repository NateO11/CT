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
    var imageURLs: [String: String]
}

struct Location: Identifiable {
    let id: String
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let category: String
    let imageLink: String
    let featured: Bool
}

struct SchoolInfo {
    let category: String
    let stats: [Int]
    let classification: String
    let statDescriptions: [String]
    let description: String
    let locations: [String]
}


struct Stat: Codable {
    var symbolName: String
    var color: Int
    var intValue: Int
    var statDescription: String
    var intSuffix: String
}



struct Review: Codable {
    let text: String
    let rating: Int
    let userID: String
    let userName: String
    let userInitials: String
    let title: String
    let timestamp: Date
    let locationName: String
    let schoolName: String
}

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let fullname: String
    var favorites: [String] = []
    var reviews: [Review] = []
    
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

var sampleColleges: [College] = [
    .init(id: "UVA", available: true, name: "University of Virginia", city: "Charlottesville, Virginia", description: "A lovely school", image: "UVA", coordinate: CLLocationCoordinate2D(latitude: 38, longitude: -77.1), color: Color.orange, imageURLs: [:]),
    .init(id: "VT", available: true, name: "Virginia Tech", city: "Blacksburg, Virginia", description: "A lovely school", image: "VT", coordinate: CLLocationCoordinate2D(latitude: 36, longitude: -77), color: .red, imageURLs: [:]),
    .init(id: "JMU", available: true, name: "James Madison University", city: "Harrisonburg, Virginia", description: "A lovely school", image: "JMU", coordinate: CLLocationCoordinate2D(latitude: 37, longitude: -77.2), color: .purple, imageURLs: [:]),
    .init(id: "GMU", available: true, name: "George Mason University", city: "Fairfax, Virginia", description: "A lovely school", image: "GMU", coordinate: CLLocationCoordinate2D(latitude: 39, longitude: -77.5), color: .green, imageURLs: [:]),
    .init(id: "W&M", available: true, name: "William and Mary", city: "Williamsburg, Virginia", description: "A lovely school", image: "WandM", coordinate: CLLocationCoordinate2D(latitude: 38, longitude: -76), color: .green, imageURLs: [:])
]


var sampleLocations: [Location] = [
    .init(id: "1", name: "Rotunda", description: "idk", coordinate: CLLocationCoordinate2D(latitude: 17, longitude: 18), category: "Landmarks", imageLink: "https://firebasestorage.googleapis.com/v0/b/collegetour-fb638.appspot.com/o/clarkLibrary.jpeg?alt=media&token=81f2a8dc-c47d-4a39-a66d-69f1f06f21e3", featured: false),
    .init(id: "2", name: "Runk", description: "I love runnk girl", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 18), category: "Dining", imageLink: "https://firebasestorage.googleapis.com/v0/b/collegetour-fb638.appspot.com/o/rotunda.jpeg?alt=media&token=dea66a98-10b6-4a0c-8b45-618650023cbd", featured: false)
]

struct TopicImagePair {
    var topic: String
    var url: String
}


var basicImagePairs: [TopicImagePair] =  [TopicImagePair(topic: "Charlottesville", url: "https://charlottesville.guide/wp-content/uploads/2019/02/trin1-1.jpg"),
    TopicImagePair(topic: "Athletics", url: "https://news.virginia.edu/sites/default/files/article_image/mens_hoops_academics_mr_header_1.jpg"),
    TopicImagePair(topic: "Dorms", url: "https://news.virginia.edu/sites/default/files/Header_New_Dorms_Aerial__SS_01-2.jpg"),
    TopicImagePair(topic: "Recreation", url: "https://rec.virginia.edu/sites/recsports2017.virginia.edu/files/indoor-pool-at-ngrc-uva.jpg"),
    TopicImagePair(topic: "Academics", url: "https://news.virginia.edu/sites/default/files/article_image/thornton_hall_engineering_fall_ss_header_3-2.jpg"),
    TopicImagePair(topic: "Dining", url: "https://wcav.images.worldnow.com/images/20205423_G.jpg?auto=webp&disable=upscale&height=560&fit=bounds&lastEditedDate=1609193636000"),
                                          
                                          
]

var UVA: College = .init(id: "UVA", available: true, name: "University of Virginia", city: "Charlottesville, Virginia", description: "A lovely school", image: "UVA", coordinate: CLLocationCoordinate2D(latitude: 38, longitude: -77.1), color: Color.orange, imageURLs: [:])
