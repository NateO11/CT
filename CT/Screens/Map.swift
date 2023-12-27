//
//  Map.swift
//  CT
//
//  Created by Griffin Harrison on 12/26/23.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift
import FirebaseFirestore

struct FirestoreLocation: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var coordinate: GeoPoint
    var category: String
}

struct MapView: View {
    @State private var firestoreLocations: [FirestoreLocation] = []

    private func fetchMapDataFromFirestore() async {
        let db = Firestore.firestore()
        
        do {
            // Change the collection name to "uvaLocations"
            let querySnapshot = try await db.collection("uvaLocations").getDocuments()
            
            self.firestoreLocations = try querySnapshot.documents.compactMap {
                let location = try $0.data(as: FirestoreLocation.self)
                return location
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }

    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Landmarks":
            return Color.orange
        case "Dining":
            return Color.gray
        case "Athletics":
            return Color.blue
        case "Study Spots":
            return Color.black
        default:
            return Color.gray
        }
    }

    private func symbolForCategory(_ category: String) -> String {
        switch category {
        case "Landmarks":
            return "building.columns.fill"
        case "Dining":
            return "fork.knife"
        case "Athletics":
            return "figure.run"
        case "Study Spots":
            return "book.fill"
        default:
            return "building"
        }
    }

    var body: some View {
        VStack {
            Map {
                ForEach(firestoreLocations) {location in
                    Marker(location.name, systemImage: symbolForCategory(location.category), coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                        .tint(colorForCategory(location.category))
                }
            }
            .onAppear {
                            Task {
                                await fetchMapDataFromFirestore()
                            }
                        }
            .mapStyle(.standard(pointsOfInterest: []))
            .mapControls {
                MapCompass()
                    .buttonBorderShape(.circle)
                    .padding()
                MapUserLocationButton()
                    .buttonBorderShape(.circle)
                    .padding()
            }
        }
    }
}

#Preview {
    MapView()
}
