
//
//  Reviews.swift
//  CT
//
//  Created by Griffin Harrison on 12/10/23.
//

import SwiftUI
import FirebaseFirestore

struct Reviews: View {
    @State private var review: String = ""
    @State private var title: String = ""
    @State private var reviewError: String?
    @State private var titleError: String?
   
    @State private var firestoreSchools: [FirestoreSchoolList] = []


    let selectedSchool: String

    init(selectedSchool: String) {
        self.selectedSchool = selectedSchool
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .padding()
                .frame(width: 380, height: 600)
                .shadow(radius: 8)
                .offset(y: -50)

            VStack {
                HStack {
                    Image(selectedSchool)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 10)
                        .padding(.vertical)

                    VStack(alignment: .leading) {
                        Text(selectedSchool)
                            .font(.headline)
                            .bold()
                            .padding(.horizontal)
                        Text(selectedSchoolCity)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                    }
                }

                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundColor(.gray)

                VStack(alignment: .leading) {
                    Text("Write a Review")
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 50)
                        .bold()
                        .font(.headline)
                        .underline()

                    TextField("Tell us more ", text: $review)
                        .padding(.horizontal, 50)
                        .bold()
                        .font(.headline)

                    // Error message for review
                    if let reviewError = reviewError {
                        Text(reviewError)
                            .foregroundColor(.red)
                            .padding(.horizontal, 50)
                            .font(.caption)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Title this Review")
                        .padding(.top, 100)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 50)
                        .bold()
                        .font(.headline)
                        .underline()

                    TextField("Add a title", text: $title)
                        .padding(.horizontal, 50)
                        .bold()
                        .font(.headline)

                    // Error message for title
                    if let titleError = titleError {
                        Text(titleError)
                            .foregroundColor(.red)
                            .padding(.horizontal, 50)
                            .font(.caption)
                    }
                }

                Spacer()

                Button(action: {validateFields() }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
            .padding(.top, 70)
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await fetchDataFromFirestore()
            }
        }
    }
    var selectedSchoolCity: String {
        return firestoreSchools.first?.city ?? "City Not Found"
    }


    func validateFields() {
        if review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            reviewError = "Review cannot be empty"
        } else {
            reviewError = nil
        }

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleError = "Title cannot be empty"
        } else {
            titleError = nil
        }
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
    Reviews(selectedSchool: "No school name found")
}
