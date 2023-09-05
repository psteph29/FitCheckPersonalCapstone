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
        
        let filename = imageName
        let fileURL = directory.appendingPathComponent(filename).appendingPathExtension("png")
        return fileURL.absoluteString
    }
}

struct FitCheckCardView: View {
    let imageName: String
    let onDelete: (() -> Void)?
    @Environment(\.editMode) var editMode
    
    var body: some View {
        ZStack {
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
            
            if editMode?.wrappedValue == .active {
                VStack {
                    HStack {
                        Button(action: {
                            onDelete?()
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(Color.red)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}
struct FitCheckListView: View {
    @Environment(\.editMode) var editMode
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
    }
    
    var body: some View {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(cards) { card in
                            FitCheckCardView(imageName: card.imagePath(), onDelete: {
                                // Replace this comment with your deletion logic
                                // Example:
                                 self.contentController.fitCheck.fitChecks.removeAll { $0.id == card.id }
                            })
                            .onTapGesture {
                                navigationPath.append(.fitCheckDetailView(card))
                            }
                        }
                    }
                    .padding(20)
                    .background(customPink)
                }
                .background(customPink)
                .navigationTitle("Fit Checks")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            isShowingInputViewSheet = true
                        }) {
                            Image(systemName: "plus")
                        }
                        EditButton()
                    }
                }
                .sheet(isPresented: $isShowingInputViewSheet, content: {
                    FitCheckInputView(contentController: contentController, navigationPath: $navigationPath, isShowing: $isShowingInputViewSheet)
                })
            }
        }
    }


//
//struct FitCheckListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FitCheckListView(contentController: FitCheckContentController.shared, navigationPath: .constant([]))
//    }
//}

