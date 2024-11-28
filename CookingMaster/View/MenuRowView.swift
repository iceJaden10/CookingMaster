//
//  MenuRowView.swift
//  CookingMaster
//
//  Created by Ching Pan CHEUNG on 11/25/24.
//

import Foundation
import SwiftUI
import CoreData

struct MenuRowView: View {
    var menu: Menu
    var recipes: [Recipe]
    @State var date = Date()
    @State private var showCalendar = false // Show or hide calendar picker
    @FetchRequest(
            entity: RecipeEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \RecipeEntity.title, ascending: true)]
        ) var fetchedRecipes: FetchedResults<RecipeEntity>
        
    
    
    var body: some View {
        
        HStack{
            let uuidStrings = menu.dishID.split(separator: ",").map(String.init)
            let uuidArray = uuidStrings.compactMap(UUID.init)
            let recipeEntity = fetchedRecipes;
            if (menu.name == "wyywyw") {
                let v = "进入了"
            }
            
            let straing = "====\(recipeEntity.first?.id?.uuidString)====\(recipeEntity.last?.id?.uuidString)"
            let recipeEntity1 = fetchedRecipes.first(where: { $0.id?.uuidString == uuidArray.first?.uuidString })
            // Find the first recipe matching the first dishID in Core Data
            if let firstDishID = uuidArray.first {
                if let recipe = recipes.first(where: { $0.id.uuidString == firstDishID.uuidString }) {
                    // Recipe is from recipesData
                    if UIImage(named: recipe.image) != nil {
                        // Image from Asset Catalog
                        Image(recipe.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .cornerRadius(10)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .overlay(
                                Text("No Image")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                } else if let recipeEntity = fetchedRecipes.first(where: { $0.id?.uuidString == firstDishID.uuidString }),
                          let imageName = recipeEntity.image, !imageName.isEmpty {
                    if let loadedImage = PersistenceController.shared.loadImageFromDocuments(fileName: imageName) {
                        // Dynamically loaded image from file
                        Image(uiImage: loadedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .cornerRadius(10)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .overlay(
                                Text("No Image")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .overlay(
                            Text("No Image")
                                .font(.caption)
                                .foregroundColor(.white)
                        )
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(
                        Text("No Recipe")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 5){
                Text(menu.name)
                    .font(.system(.title3, design: .serif))
                    .padding(.bottom,15)
                HStack{
                    DatePicker("Date",
                               selection: $date,
                               displayedComponents: [.date]
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    .font(.title3)
                    .labelsHidden()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.colorGreenAdaptive.opacity(0.3))
                    )
                    .padding(.vertical, 10)
                    Spacer()
                }
            }
        }
    }
}

struct MenuRowView_Previews: PreviewProvider{
    static var previews: some View{
        MenuRowView(menu: menuData[0], recipes: recipesData)
    }
}
