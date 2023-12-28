//
//  explorePage.swift
//  CT
//
//  Created by Nate Owen on 12/26/23.
//
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct ExplorePage: View {
    @State private var firestoreSchools: [FirestoreSchoolList] = []
    @State private var selectedSchool: String?


    var body: some View {
        NavigationView {
            ScrollView() {
                VStack {
                    // Top Buttons Section
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 300)
                                .edgesIgnoringSafeArea(.all)

                            VStack(alignment: .leading) {
                                Text("Explore Schools")
                                    .font(.largeTitle)
                                    .padding()
                                    .foregroundColor(.white)
                                    .bold()
                                    .fontWeight(.heavy)

                                HStack {
                                    VStack(alignment: .leading) {
                                        StyledButton(icon: "book", title: "Schools", destination: SchoolSelect())
                                        StyledButton(icon: "mappin", title: "Locations", destination: LocationsSearch())
                                    }
                                    VStack(alignment: .leading) {
                                        StyledButton(icon: "graduationcap", title: "Academics", destination: SchoolSelect())
                                        StyledButton(icon: "sportscourt", title: "Athletics", destination: SchoolSelect())
                                    }
                                }
                            }
                            .padding(.leading, 20)
                        }
                    }
                    .padding(.bottom, 10)

                    // Large Image Section
                    ZStack {
                        Image("stockimage1")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)

                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            Text("Discover Your Future")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)

                            Text("Read reviews from current students to help you learn information about what you want in a dream school ")
                                .font(.headline)
                                .foregroundColor(.white)

                            Button(action: { }) {
                                Text("Reviews")
                                    .foregroundColor(.black)
                                    .padding()
                                    .bold()
                                    .background(Color.white)
                                    .cornerRadius(30)
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom, 50)

                    // Small Images Horizontal Section
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(firestoreSchools) { school in
                                VStack(alignment: .leading) {
                                    NavigationLink(
                                        destination: SchoolView(selectedSchool: school.image),
                                        label: {
                                            Image("\(school.image)")
                                                .resizable()
                                                .cornerRadius(20)
                                                .frame(width: 225, height: 200)
                                                .clipped()
                                        }
                                    )
                                    .onTapGesture {
                                        selectedSchool = school.name
                                    }
                                    VStack(alignment: .leading, spacing: 8) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(school.name)")
                                                .fontWeight(.heavy)
                                                .font(.title3)
                                            Text("\(school.city)")
                                                .fontWeight(.light)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }

                    
                    // Large Image Section
                    ZStack {
                        Image("stockimage2")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)

                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            Text("Find Your Next Step")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)

                            Text("Read reviews from current students to help you learn information about what you want in a dream school ")
                                .font(.headline)
                                .foregroundColor(.white)

                            Button(action: { }) {
                                Text("Reviews")
                                    .foregroundColor(.black)
                                    .padding()
                                    .bold()
                                    .background(Color.white)
                                    .cornerRadius(30)
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom, 50)
                    
                    // Small Images Horizontal Section
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(firestoreSchools) { school in
                                VStack(alignment: .leading) {
                                    NavigationLink(
                                        destination: SchoolView(selectedSchool: school.image),
                                        label: {
                                            Image("\(school.image)")
                                                .resizable()
                                                .cornerRadius(20)
                                                .frame(width: 225, height: 200)
                                                .clipped()
                                        }
                                    )
                                    .onTapGesture {
                                        selectedSchool = school.name
                                    }
                                    VStack(alignment: .leading, spacing: 8) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(school.name)")
                                                .fontWeight(.heavy)
                                                .font(.title3)
                                            Text("\(school.city)")
                                                .fontWeight(.light)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                    
                    // Large Image Section
                    ZStack {
                        Image("stockimage3")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)

                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            Text("I get no bitches")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)

                            Text("Read reviews from current students to help you learn information about what you want in a dream school ")
                                .font(.headline)
                                .foregroundColor(.white)

                            Button(action: { }) {
                                Text("Reviews")
                                    .foregroundColor(.black)
                                    .padding()
                                    .bold()
                                    .background(Color.white)
                                    .cornerRadius(30)
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom, 50)
                    
                    
                    
                    
                    
                    
                    //break
                    
                }
                .onAppear {
                    Task {
                        await fetchDataFromFirestore()
                    }
                }
            }
        }
    }

    struct StyledButton<Destination: View>: View {
        let icon: String
        let title: String
        let destination: Destination

        var body: some View {
            NavigationLink(destination: destination) {
                HStack(alignment: .center) {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .bold()
                    Text(title)
                        .foregroundColor(.blue)
                        .padding(.leading, 5)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            }
            .frame(width: 170, height: 60)
            .background(Color.white)
            .cornerRadius(40)
        }
    }

    struct FirestoreSchoolList: Identifiable, Codable {
        @DocumentID var id: String?
        var city: String
        var image: String
        var name: String
    }

    private func fetchDataFromFirestore() async {
        let db = Firestore.firestore()

        do {
            let documentSnapshots = try await db.collection("Schools")
                .whereField(FieldPath.documentID(), in: ["UVA", "JMU", "VT", "WandL", "GMU"])
                .getDocuments()

            firestoreSchools = try documentSnapshots.documents.compactMap { document in
                try document.data(as: FirestoreSchoolList.self)
            }

            if firestoreSchools.isEmpty {
                print("No documents found or could not be parsed.")
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }

}



struct ExplorePage_Previews: PreviewProvider {
    static var previews: some View {
        ExplorePage()
    }
}
