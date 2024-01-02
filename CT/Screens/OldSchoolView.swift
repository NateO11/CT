//
//  SchoolView.swift
//  CT
//
//  Created by Nate Owen on 12/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct OldSchoolView: View {
    let selectedSchool: String
    @State private var firestoreSchools: [FirestoreSchoolList] = []
    @State private var isShowingReviews = false



    init(selectedSchool: String) {
        self.selectedSchool = selectedSchool
    }

    var body: some View {
        NavigationStack{
                ScrollView{
                    VStack {
                        
                        Image(selectedSchoolImage)
                            .resizable()
                            .frame(height: 250)
                            .scaledToFill()
                            .clipped()
                            .padding()
                        
                        
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

                        // Button to navigate to the "Write a Review" screen
                        Button("Write a Review") {
                                isShowingReviews = true
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                            .padding(.top, 10)

                            // Define the navigation destination
                            .navigationDestination(isPresented: $isShowingReviews) {
                                Reviews(selectedSchool: selectedSchoolImage)
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
        }
        
//
//    All of these are returning the firestore name/city/image and then text not found as a placeholder
//
//
    
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

//
//    I beleive this is acting as an enumerated data structure
//
//
//
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

