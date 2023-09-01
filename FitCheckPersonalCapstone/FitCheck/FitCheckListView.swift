//
//  FitCheckListView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/18/23.
//

import SwiftUI

struct fitCheckCard: Identifiable {
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

struct FitCheckCardView: View {
    
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



struct FitCheckListView: View {
    
    @State private var editMode = EditMode.inactive
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var contentController: FitCheckContentController
    
    @Binding var navigationPath: [AppView]
    
    @State private var isShowingInputViewSheet = false
    
    let customPink = Color(red: 255/255, green: 230/255, blue: 232/255)
    
    let dismissView: (() -> Void)?
    
    var columns: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    
    var cards: [OOTD] {
        return contentController.fitCheck.fitChecks
    }
    
    init(contentController: FitCheckContentController, navigationPath: Binding<[AppView]>, dismissView: (() -> Void)? = nil) {
        self.contentController = contentController
        self._navigationPath = navigationPath
        self.dismissView = dismissView
        print(cards.count)
    }
    
    var body: some View {
                NavigationView {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(cards) { card in
                    CardView(imageName: card.imagePath())
                        .onTapGesture {
                            navigationPath.append(.fitCheckDetailView(card))
                        }
                }
                .onDelete(perform: deleteCard)
                
            }
            .padding(20)
            .background(customPink)
        }
        .background(customPink)
        .navigationTitle("Fit Checks")
        .toolbar {
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                Button(action: {
//                    isShowingInputViewSheet = true
//                }) {
//                    Image(systemName: "plus")
//                }
               EditButton()
                
                
                
            }
            .environment(\.editMode, $editMode)
        }
                
        
        .sheet(isPresented: $isShowingInputViewSheet, content: {
            FitCheckInputView(contentController: contentController, navigationPath: $navigationPath)
        })
                }
    
    func deleteCard(at offsets: IndexSet) {
        contentController.fitCheck.fitChecks.remove(atOffsets: offsets)
    }
   
    }

    

//
//struct FitCheckListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FitCheckListView(contentController: FitCheckContentController.shared, navigationPath: .constant([]))
//    }
//}

