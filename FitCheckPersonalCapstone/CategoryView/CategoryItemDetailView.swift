//
//  CategoryItemDetailView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/5/23.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var imageName: String
    
    
    func imagePath() -> String {
        let fileManager = FileManager.default
        let directoryURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let directory = directoryURLs.first else {
            return ""
        }
        //        This guard statement checks that the directoryURLs array is not empty, and then proceeds with creating the file path and saving the image data
        
        let filename = imageName
        let fileURL = directory.appendingPathComponent(filename).appendingPathExtension("png")
        return fileURL.absoluteString
    }
}

struct CardView: View {
    let imageName: String

    var body: some View {
        if let imageData = try? Data(contentsOf: URL(string: imageName)!),
           let img = UIImage(data: imageData) {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 200)
                .cornerRadius(12)
                .clipped()
        } else {
            Text("Image not found")
        }
    }
}



struct CategoryItemDetailView: View {
    
    @ObservedObject var contentController: ClosetContentController
    var category: ClothingCategory
    
    @Binding var navigationPath: [AppView]
    
    var columns: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    
    var cards: [ClothingArticle] {
        var filteredArticles = [ClothingArticle]()
        for categoryObject in contentController.theCloset.clothingCategories {
            if categoryObject.title == category.id {
                filteredArticles.append(contentsOf: categoryObject.clothingArticles)
            }
        }
        return filteredArticles
    }
    
    init(contentController: ClosetContentController, category: ClothingCategory, navigationPath: Binding<[AppView]>) {
        self.contentController = contentController
        self.category = category
        self._navigationPath = navigationPath
        print(cards.count)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cards) { card in
                        CardView(imageName: card.imagePath())
                    }
                }
                .padding(20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigationPath.append(.inputClothingView(self.category))
                        
                    })
                    {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle(category.title)
            .navigationBarTitleDisplayMode(.inline)
            //            Write switch to display the name of the category depending on the category you are in
        }
    }
}

struct CategoryItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemDetailView(contentController: ClosetContentController.shared, category: ClothingCategory(title: "Tees"), navigationPath: .constant([]))
    }
}

