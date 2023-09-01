//
//  ClothingCategory.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/10/23.
//

import Foundation

struct ClothingCategory: Identifiable, Codable, Hashable {
    var id: String { title }
    var title: String
    var imageName: String {
        clothingArticles.first?.imagePath() ?? "Closet"
    }
    
    var clothingArticles: [ClothingArticle] = []
}
