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
        Image(systemName: symbolForCategory(category))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .frame(width: dimensions, height: dimensions)
            .padding()
            .background(colorForCategory(category))
            .clipShape(Circle())
        // generates a view that uses the category's associated symbol and color
        if showTextBelow == true {
            Text(category)
        }
    }
}

func colorForCategory(_ category: String) -> Color {
    // function to define a color for each location type
    switch category {
    case "Landmarks":
        return Color.orange
    case "Dining":
        return Color.black
    case "Athletics":
        return Color.red
    case "Study Spots":
        return Color.blue
    case "Engineering":
        return Color.pink
    case "Law":
        return Color.blue
    case "Business":
        return Color.blue
    case "Living":
        return Color.blue
    case "Restaurants":
        return Color.blue
    case "Nature":
        return Color.green
    case "Parking":
        return Color.blue
    case "Local Area":
        return Color.blue
    case "Stadiums":
        return Color.blue
    case "Health":
        return Color.blue
    default:
        return Color.gray
    }
    // the locations listed here are a lot more extensive than they will actually be in the builds, but it gives more felxibility if we want to expand categories
}

func symbolForCategory(_ category: String) -> String {
    // function to define a symbol for each location type
    switch category {
    case "Landmarks":
        return "building.columns.fill"
    case "Dining":
        return "fork.knife"
    case "Athletics":
        return "figure.tennis"
    case "Study Spots":
        return "book.fill"
    case "Engineering":
        return "brain.filled.head.profile"
    case "Law":
        return "books.vertical.fill"
    case "Business":
        return "briefcase.fill"
    case "Living":
        return "house.fill"
    case "Restaurants":
        return "cup.and.saucer.fill"
    case "Nature":
        return "figure.hiking"
    case "Parking":
        return "p.square.fill"
    case "Local Area":
        return "globe"
    case "Stadiums":
        return "trophy.fill"
    case "Health":
        return "stethoscope"
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
    @State var showAllButton = false
    
    var body: some View {
        VStack {
            if showLandmarksButton {
                Button("") {
                    selectedCategory = "Landmarks"
                    self.showMenu()
                }
                .buttonStyle(CategoryButton(category: "Landmarks"))
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
                    selectedCategory = "Study Spots"
                    self.showMenu()        
                }
                .buttonStyle(CategoryButton(category: "Study Spots"))
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
        withAnimation {
            showLandmarksButton.toggle()
            showAthleticsButton.toggle()
            showDiningButton.toggle()
            showStudyButton.toggle()
            showAllButton.toggle()
        }
        
    }
    
}
