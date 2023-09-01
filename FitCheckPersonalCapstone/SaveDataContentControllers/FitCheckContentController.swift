//
//  FitCheckContentController.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/18/23.
//

import Foundation
import UIKit

class FitCheckContentController: ObservableObject {
    static var shared = FitCheckContentController()
    @Published var fitCheck: FitCheck

    func getOOTD(date: Date) -> OOTD? {
        for ootd in fitCheck.fitChecks {
            if isDate(date, inSameDayAs: ootd.date) {
                return ootd
            }
        }
        return nil
    }

    func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func addFitCheck(imageURL: String, date: Date) {
        let newOOTD = OOTD(imageURL: imageURL, date: date)
        fitCheck.fitChecks.append(newOOTD)
        save()
    }

    private init() {
        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let fileURL = directory.appendingPathComponent("fitCheck.data")
        print(fileURL) //if on the simulator you can copy this path and open in Finder and delete it to restart
        if FileManager.default.fileExists(atPath: fileURL.path) {
            
            do {
                let data = try Data(contentsOf: fileURL)
                fitCheck = try JSONDecoder().decode(FitCheck.self, from: data)
            } catch {
                print(error)
                fitCheck = FitCheck(fitChecks: [])
            }
            
        } else {
            fitCheck = FitCheck(fitChecks: [])
        }
    }
//    The init Method is the initializer for the ClosetContentController class. When an instance of this class is created, this method
//      1. Determines the directory where the data file should be saved/loaded -> documentDirectory
//      2. Defines the name of the data file (closet.data) and constructs the full path to it
//      3. Checks if a file at that path already exists: if it does, it attempts to load the data from that file, decode the JSON data to a 'TheCloset' object, and assigns it to 'theCloset'. If it doesn't, it initializes 'theCloset' with an empty array of 'ClothingArticle'
    
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

    
    
    func save() {
        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let fileURL = directory.appendingPathComponent("fitCheck.data")
        
        do {
            let data = try JSONEncoder().encode(fitCheck)
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }
//    This method is responsible for saving the current state of 'theCloset' to a local file. It encodes 'theCloset' to a JSON data object using JSONEncoder. It also writes this data object to a file at the specified path ('closet.data').
//    FileManager is a class that lets you interact with the file system of the device. Here it is being used to get the 'documentDirectory' (a directory where the app can save user data) and to check if a file exists at a certain path.
    

}
