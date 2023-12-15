import SwiftUI

struct SchoolSelect: View {
    
    @State private var searchText: String = ""
    @State private var selected: String = ""
    
    var filteredSchools: [School] {
        if searchText.isEmpty {
            return schools
        } else {
            return schools.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
                Text("Select a School")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading, 10)
                
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                
            //spotty here but can kinda figure it out
                List {
                    ForEach(filteredSchools) { school in
                        NavigationLink(destination: SchoolViewer(selectedSchool: school)) {
                            SchoolListItem(school: school)
                    }
                }
            }
        }
    }
}


/// lets
struct SchoolListItem: View {
    var school: School
       
    var body: some View {
            ZStack {
                
                Image(school.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .blur(radius: 2)
                
                HStack{
                    VStack{
                        Spacer()
                 
                Text(school.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.gray)
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                    .padding(.leading, 10)
            }
                Spacer()
                }
            }
            .clipped()
            .cornerRadius(8)
        }

}

struct SchoolSelect_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SchoolSelect()
        }
    }
}
