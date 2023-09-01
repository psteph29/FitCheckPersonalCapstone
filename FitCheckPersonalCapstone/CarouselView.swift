//
//  CarouselView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/31/23.
//


import SwiftUI

struct Box: Identifiable, Hashable {
//    Contains a box with the images and the title
    var id: Int
    let title, imageURL: String
}

struct CarouselView: View {
    @EnvironmentObject var contentController: ClosetContentController
//    @ObservedObject var contentController = ClosetContentController.shared
    
    @State private var selectedCardIDs = [String: Bool]()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(contentController.theCloset.clothingCategories, id: \.self) { category in
                        VStack {
                            Text(category.title)
                                .bold()
                            ScrollView(.horizontal) {
                                HStack(spacing: 16) {
                                    ForEach(category.clothingArticles) { article in
//                                        CardView(imageName: article.imagePath())
                                        SelectableCardView(imageURL: article.imagePath(), isSelected: selectedCardIDs[article.id, default: false]) {
                                            selectedCardIDs[article.id, default: false].toggle()
                                        }
                                        .frame(width: 80, height: 100)
                                        .cornerRadius(12)
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .navigationTitle("Clothing Collection")
            }
        }
    }
}

struct SelectableCardView: View {
    var imageURL: String
    var isSelected: Bool
    var didTap: () -> Void
    
    var body: some View {
        Button {
            didTap()
        } label: {
            ZStack {
                CardView(imageName: imageURL)
                    .frame(width: 80, height: 100)
                    .cornerRadius(12)
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .opacity(isSelected ? 1 : 0)
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
