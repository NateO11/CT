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
    let category: String
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: symbolForCategory(category))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .frame(width: 33,height: 33)
            .padding()
            .background(colorForCategory(category))
            .clipShape(Circle())
    }
}

func colorForCategory(_ category: String) -> Color {
    // function to define a color for each location type
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
        return Color.pink
    }
}

func symbolForCategory(_ category: String) -> String {
    // function to define a symbol for each location type
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
        return "gearshape.fill"
    }
}

struct CategorySelectView: View {
    @Binding var selectedCategory: String
    @Binding var showCategorySelect: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select which type of locations you want!")
            HStack(spacing: 12) {
                Button("") {
                    selectedCategory = "Landmarks"
                    showCategorySelect.toggle()
                }
                .buttonStyle(CategoryButton(category: "Landmarks"))
                
                Button("") {
                    selectedCategory = "Athletics"
                    showCategorySelect.toggle()
                }
                .buttonStyle(CategoryButton(category: "Athletics"))
                
                Button("") {
                    selectedCategory = "Dining"
                    showCategorySelect.toggle()
                }
                .buttonStyle(CategoryButton(category: "Dining"))
                
                Button("") {
                    selectedCategory = "Study Spots"
                    showCategorySelect.toggle()
                }
                .buttonStyle(CategoryButton(category: "Study Spots"))
                
                Button("") {
                    selectedCategory = "All"
                    showCategorySelect.toggle()
                }
                .buttonStyle(CategoryButton(category: "All"))
            }
        }
    }
}
