//
//  MapCategoryManager.swift
//  CT
//
//  Created by Griffin Harrison on 12/28/23.
//
import SwiftUI
import MapKit
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct CategoryButton: ButtonStyle {
    // button style to simplify the category select screen and minimize repetitiveness
    let category: String
    let showTextBelow: Bool = false
    // possibility to show text below, just a format option
    var dimensions: CGFloat = 33
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Image(systemName: symbolForCategory(category))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: dimensions, height: dimensions)
                .padding()
                .background(colorForCategory(category))
                .clipShape(Circle())
                .shadow(radius: 10)
            // generates a view that uses the category's associated symbol and color
            if showTextBelow == true {
                Text(category)
            }
        }
        
    }
}

func colorForCategory(_ category: String) -> Color {
    // function to define a color for each location type
    switch category {
    case "Landmark":
        return Color.orange
    case "Dining":
        return Color.black
    case "Athletics":
        return Color.red
    case "Library":
        return Color.blue
    case "School Building":
        return Color.init(hex: 3556687)
    case "Dorms":
        return Color.init(hex: 4251856)
    default:
        return Color.gray
    }
    // the locations listed here are a lot more extensive than they will actually be in the builds, but it gives more felxibility if we want to expand categories
}

func symbolForCategory(_ category: String) -> String {
    // function to define a symbol for each location type
    switch category {
    case "Landmark":
        return "building.columns.fill"
    case "Dining":
        return "fork.knife"
    case "Athletics":
        return "figure.tennis"
    case "Library":
        return "book.fill"
    case "School Building":
        return "building.2.fill"
    case "Dorms":
        return "house.fill"
    case "All":
        return "globe"
    case "Close":
        return "xmark"
    case "Expand" :
        return "square.stack.3d.up"
    default:
        return "gearshape.fill"
    }
    // same idea as the color function, we don't actually use all of these categories but have the option to build in more if needed
}



struct ExpandedCategorySelect: View {
    @Binding var selectedCategory: String
    @State private var isExpanded = false
    @State var showLandmarksButton = false
    @State var showAthleticsButton = false
    @State var showDiningButton = false
    @State var showStudyButton = false
    @State var showSchoolButton = false
    @State var showDormButton = false
    @State var showAllButton = false
    
    var body: some View {
        VStack(spacing: 5) {
            
            if showLandmarksButton {
                Button("") {
                    selectedCategory = "Landmark"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "Landmark"))
            }
            if showAthleticsButton {
                Button("") {
                    selectedCategory = "Athletics"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "Athletics"))
            }
            if showDiningButton {
                Button("") {
                    selectedCategory = "Dining"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "Dining"))
            }
            if showStudyButton {
                Button("") {
                    selectedCategory = "Library"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "Library"))
            }
            if showDormButton {
                Button("") {
                    selectedCategory = "Dorms"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "Dorms"))
            }
            if showSchoolButton {
                Button("") {
                    selectedCategory = "School Building"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "School Building"))
            }
            if showAllButton {
                Button("") {
                    selectedCategory = "All"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "All"))
            }
            Button("") {
                withAnimation {
                    self.showMenu()
                }
                
            }.buttonStyle(CategoryButton(category: showAllButton ? "Close" : "Expand", dimensions: 40)).contentTransition(.symbolEffect(.replace))

        }
        .transition(.move(edge: .top))
    }
    
    func showMenu() {
            withAnimation(.snappy(duration: 0.4)) {
            showLandmarksButton.toggle()
            showAthleticsButton.toggle()
            showDiningButton.toggle()
            showStudyButton.toggle()
            showDormButton.toggle()
            showSchoolButton.toggle()
            showAllButton.toggle()
        }
        
    }
    
}
