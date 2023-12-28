//
//  SchoolView.swift
//  CT
//
//  Created by Nate Owen on 12/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct SchoolView: View {
    let selectedSchool: String
    @State private var firestoreSchools: [FirestoreSchoolList] = []


    init(selectedSchool: String) {
        self.selectedSchool = selectedSchool
    }

    var body: some View {
        ScrollView{
            
            VStack {
                Image(selectedSchool)
                    .resizable()
                    .frame(height: 250)
                    .scaledToFill()
                    .clipped()
                    .padding(.top)
                
                HStack {
                    Text(selectedSchoolName)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                    Spacer() // Pushes the text to the leading edge
                }
                
                HStack {
                    Text(selectedSchoolCity)
                        .font(.title)
                        .fontWeight(.light)
                        .padding(.horizontal)
                    Spacer() // Pushes the text to the leading edge
                }
                HStack{
                    Text(selectedSchoolDescription)
                        .font(.headline)
                        .fontWeight(.light)
                        .padding(.all)
                    Spacer()
                }
            }
        }
            .navigationBarTitle(" ")
            
            
            .onAppear {
                Task {
                    await fetchDataFromFirestore()
                }
            }
        }
    
    
    var selectedSchoolName: String {
        return firestoreSchools.first?.name ?? "School Name Not Found"
    }
    var selectedSchoolCity: String {
        return firestoreSchools.first?.city ?? "City Not Found"
    }
    var selectedSchoolImage: String {
        return firestoreSchools.first?.image ?? "Image Not Found"
    }
    var selectedSchoolDescription: String {
        return firestoreSchools.first?.description ?? "Description Not Found"
    }

    struct FirestoreSchoolList: Identifiable, Codable {
        @DocumentID var id: String?
        var city: String
        var image: String
        var name: String
        var description: String
    }

    private func fetchDataFromFirestore() async {
        let db = Firestore.firestore()

        do {
            let documentSnapshots = try await db.collection("Schools")
                .whereField(FieldPath.documentID(), in: [selectedSchool])
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

#Preview {
    SchoolView(selectedSchool: "Image")
}
