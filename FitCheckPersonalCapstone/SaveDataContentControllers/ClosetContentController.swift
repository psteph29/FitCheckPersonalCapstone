//
//  ClosetContentController.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/16/23.

//This code defines a basic structure for managing a collection of clothing articles, loading them from disk when the app launches, and saving them back to disk as needed. The 'ClosetContentController' class is designed= to be used as an observed object in a SwiftUI view, so the UI will update when 'theCloset' changes.


import Foundation
import UIKit

class ClosetContentController: ObservableObject {
    //This class is responsible for managing the data for TheCloset. It is designed to handle the saving and loading of TheCloset data to and from a local file.
    static var shared = ClosetContentController()
    @Published var theCloset: TheCloset
//    This is a published property, meaning that any SwiftUI view that observes an instance of this class will be notified when theCloset changes, prompting the view to re-render.
    
    func addClothingArticle(category: ClothingCategory, imageURL: String) {
        let newArticle = ClothingArticle(imageURL: imageURL)
        theCloset.add(article: newArticle, to: category)
        save()
    }

    private init() {
        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let fileURL = directory.appendingPathComponent("closet.data")
        print(fileURL) //if on the simulator you can copy this path and open in Finder and delete it to restart
        if FileManager.default.fileExists(atPath: fileURL.path) {
            
            do {
                let data = try Data(contentsOf: fileURL)
                theCloset = try JSONDecoder().decode(TheCloset.self, from: data)
            } catch {
                print(error)
                theCloset = TheCloset(clothingCategories: [])
            }
            
        } else {
            theCloset = TheCloset(clothingCategories: [])
        }
    }
//    The init Method is the initializer for the ClosetContentController class. When an instance of this class is created, this method
//      1. Determines the directory where the data file should be saved/loaded -> documentDirectory
//      2. Defines the name of the data file (closet.data) and constructs the full path to it
//      3. Checks if a file at that path already exists: if it does, it attempts to load the data from that file, decode the JSON data to a 'TheCloset' object, and assigns it to 'theCloset'. If it doesn't, it initializes 'theCloset' with an empty array of 'ClothingArticle'
    
    func save() {
        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let fileURL = directory.appendingPathComponent("closet.data")
        
        do {
            let data = try JSONEncoder().encode(theCloset)
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }
//    This method is responsible for saving the current state of 'theCloset' to a local file. It encodes 'theCloset' to a JSON data object using JSONEncoder. It also writes this data object to a file at the specified path ('closet.data').
//    FileManager is a class that lets you interact with the file system of the device. Here it is being used to get the 'documentDirectory' (a directory where the app can save user data) and to check if a file exists at a certain path.
    
    func saveImageToDisk(image: UIImage) -> String? {
        let fileManager = FileManager.default
        let directoryURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let directory = directoryURLs.first else {
            return ""
        }
//        This guard statement checks that the directoryURLs array is not empty, and then proceeds with creating the file path and saving the image data
        
        let fileName = UUID().uuidString
        let fileURL = directory.appendingPathComponent(fileName).appendingPathExtension("png")
        
        if let data = image.pngData() {
            do {
                try data.write(to: fileURL)
                return fileName
            } catch {
                print(error)
                return ""
            }
        }
        return ""
    }

}
