//
//  TheCloset.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/28/23.
//


import Foundation

struct TheCloset: Codable {
    var clothingCategories: [ClothingCategory]
    
   mutating func add(article: ClothingArticle, to category: ClothingCategory) {
        // Search for the category in the existing list of categories
        if let index = clothingCategories.firstIndex(where: { $0.id == category.id }) {
            // Add the article to the found category
            clothingCategories[index].clothingArticles.append(article)
        } else {
            // If the category is not found, create a new category with the article and add it to the list
            var newCategory = category
            newCategory.clothingArticles = [article]
            clothingCategories.append(newCategory)
        }
    }
}
    
//    An array of clothingArticle objects representing different articles of clothing

//Represents a closet that contains a collection of clothing articles
