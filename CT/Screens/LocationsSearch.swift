//
//  LocationsSearch.swift
//  CT
//
//  Created by Nate Owen on 12/28/23.
//

import SwiftUI
import FirebaseFirestore

/* struct LocationsSearch: View {
    
    @State private var schools: [SchoolModel] = []

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Search by Location")
                        .font(.largeTitle)
                        .padding(.all)
                        .foregroundColor(.black)
                        .bold()
                        .fontWeight(.heavy)

                    Spacer()
                }
                HStack {
                    Text("Virginia")
                        .font(.title)
                        .padding(.all)
                        .foregroundColor(.black)
                        .bold()
                        .fontWeight(.heavy)
                    Spacer()
                }
                
                List(schools, id: \.id) { school in
                    NavigationLink(destination: SchoolView(selectedSchool: school.image)) {
                        HStack {
                            // Display the image
                            Image(school.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 10)

                            // Display the name and city
                            VStack(alignment: .leading) {
                                Text(school.name)
                                    .font(.headline)
                                    .bold()
                                Text(school.city)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 30, leading: 10, bottom: 10, trailing: 10))
            }
            .onAppear {
                fetchDataFromFirestore()
            }
        }
    }

    func fetchDataFromFirestore() {
        let db = Firestore.firestore()

        db.collection("Schools").getDocuments { snapshot, _ in
            if let documents = snapshot?.documents {
                self.schools = documents.compactMap { document in
                    guard let name = document.data()["name"] as? String,
                          let city = document.data()["city"] as? String,
                          let image = document.data()["image"] as? String else {
                        return nil
                    }
                    return SchoolModel(id: document.documentID, name: name, city: city, image: image)
                }
            } else {
                // Placeholder data if error occurs
                self.schools = [SchoolModel(id: "1", name: "Error fetching data", city: "Error", image: "Error")]
            }
        }
    }
}

struct SchoolModels: Identifiable {
    var id: String
    var name: String
    var city: String
    var image: String
}



#Preview {
    LocationsSearch()
}
*/
