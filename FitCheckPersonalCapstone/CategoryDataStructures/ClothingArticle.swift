//
//  ClothingArticle.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/28/23.
//

import Foundation


struct ClothingArticle: Codable, Identifiable, Equatable, Hashable {
    var id: String { imageURL }
//    let category: ClothingCategory
    let imageURL: String
    
    func imagePath() -> String {
        let fileManager = FileManager.default
        let directoryURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let directory = directoryURLs.first else {
            return ""
        }
//        This guard statement checks that the directoryURLs array is not empty, and then proceeds with creating the file path and saving the image data
        
        let filename = imageURL
        let fileURL = directory.appendingPathComponent(filename).appendingPathExtension("png")
        return fileURL.absoluteString
    }
}
//Represents a single article of clothing
