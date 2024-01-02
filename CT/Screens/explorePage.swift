//
//  explorePage.swift
//  CT
//
//  Created by Nate Owen on 12/26/23.
//
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
/*
struct ExplorePage: View {
    
    // this is an array list from the schools that are chosen to be displayed
    @State private var firestoreSchools: [FirestoreSchoolList] = []
    @State private var selectedSchool: String?
    
    // string to hold the ID name
    let ID: String


    init(ID: String) {
        self.ID = ID
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    // Top Buttons Section
                    VStack {
                        ZStack {
                            BlueRectangleView()

                            VStack(alignment: .leading) {
                                welcomeNameText(username: ID)
                                underlineRectangle()
                                explorePageTitleText()

                                HStack {
                                    VStack(alignment: .leading) {
                                        StyledButton(icon: "book", title: "Schools", destination: SchoolSelect())
                                        StyledButton(icon: "mappin", title: "Locations", destination: SchoolSelect())
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
                        largeImageBackground(imageName: "stockimage1")

                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            largeImageTitleText(text: "Discover Your Future")
                            largeImageSmallText(text: "Read reviews from current students to help you learn information about what you want in a dream school")
                            largeReviewsButton()
                        }
                        .padding()
                    }
                    .padding(.bottom, 50)
                    
                    // Small Images Horizontal Section
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            
                            //display list for each school defined
                            ForEach(firestoreSchools) { school in
                                VStack(alignment: .leading) {
                                    NavigationLink(
                                        destination: OldSchoolView(selectedSchool: school.image),
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
                        largeImageBackground(imageName: "stockimage2")

                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            largeImageTitleText(text: "Find Your Next Step")
                            largeImageSmallText(text: "Read reviews from current students to help you learn information about what you want in a dream school")
                            largeMapsButton()
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
                                        destination: OldSchoolView(selectedSchool: school.image),
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
                        largeImageBackground(imageName: "stockimage3")

                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            largeImageTitleText(text: "Find Your Next Step")
                            largeImageSmallText(text: "Read reviews from current students to help you learn information about what you want in a dream school")
                            largeReviewsButton()
                        }
                        .padding()
                    }
                    .padding(.bottom, 50)
                    
                    bottomText(text: "Contact us at CollegeTour@gmail.com")
                    
                }
                .onAppear {
                    Task {
                        await fetchDataFromFirestore()
                    }
                }
            }
           
        }
        .navigationBarBackButtonHidden(true)
    }

    
//    
//    
//    TOP SECTION
//
    
    struct BlueRectangleView: View {
        var body: some View {
            Rectangle()
                .fill(Color.blue)
                .frame(height: 300)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    
    struct explorePageTitleText: View {
        var body: some View {
            Text("Explore Schools")
                .font(.largeTitle)
                .padding(.bottom)
                .foregroundColor(.white)
                .bold()
                .fontWeight(.heavy)
        }
    }
    
    struct welcomeNameText: View {
        let username: String
        
        @State private var name: String = "'placeholdername'"

        var body: some View {
            Text("Welcome \(name)")
                .font(.title)
                .padding(.bottom, 1)
                .foregroundColor(.white)
                .onAppear {
                    Task {
                        await getUsername(forID: username)
                    }
                }
        }

        func getUsername(forID documentID: String) async {
            let db = Firestore.firestore()

            do {
                let documentSnapshot = try await db.collection("Users").document(documentID).getDocument()

                if let username = documentSnapshot.data()?["Username"] as? String {
                    // Save the username to the variable name
                    self.name = username
                    print("Username found: \(username)")
                } else {
                    print("No Username field found in the document with ID: \(documentID)")
                }
            } catch {
                print("Error getting document: \(error)")
            }
        }
    }

    
    struct underlineRectangle: View {
        var body: some View {
            Rectangle()
                .fill(Color.white)
                .frame(width: 250,height: 1)
                .edgesIgnoringSafeArea(.all)
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
            .frame(width: 160, height: 60)
            .background(Color.white)
            .cornerRadius(40)
        }
    }
    
//    
//    LARGE IMAGE SECTION
//
//    
    
    struct largeImageBackground: View {
        
        let imageName: String
        
        var body: some View {
            
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
        }
    }
    
    struct largeImageTitleText: View {
        
        let text: String
        
        var body: some View {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.white)
        }
    }
    
    struct largeImageSmallText: View {
        
        let text: String

        var body: some View {
            
            Text(text)
                .font(.headline)
                .foregroundColor(.white)

        }
    }
    
    struct largeReviewsButton: View {
        var body: some View {
            
            Button(action: { }) {
                Text("Reviews")
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .background(Color.white)
                    .cornerRadius(30)
            }
        }
    }
    
    struct largeMapsButton: View {
        var body: some View {
            
            HStack{
                Spacer()
                Button(action: { }) {
                    Text("View Maps")
                        .foregroundColor(.black)
                        .padding()
                        .bold()
                        .background(Color.white)
                        .cornerRadius(30)
                }
            }
        }
    }
    
//    
//    
//    FOOTER TEXT
//
    
    struct bottomText: View {
      
        let text: String
        
        var body: some View {
            
            Text(text)
                .font(.caption2)
                .fontWeight(.thin)
                
        }
    }
 
//    
//    FIREBASE
//
    
    

    
    
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
        ExplorePage(ID: "text")
    }
}
*/
