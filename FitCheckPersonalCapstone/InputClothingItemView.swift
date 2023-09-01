//
//  InputClothingItemView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/4/23.

import SwiftUI

struct InputClothingItemView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Environment(\.dismiss) var dismiss
    @State private var navigateToCategoryItemDetailView = false
    
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var showingOptions = false
    
    let customPink = Color(red: 255/255, green: 230/255, blue: 232/255)
    
    @State private var selectedCategory: ClothingCategory? = nil
    
    @EnvironmentObject var contentController: ClosetContentController
    
    @Binding var navigationPath: [AppView]
    
    var initialCategory: ClothingCategory?

    init(navigationPath: Binding<[AppView]>, initialCategory: ClothingCategory? = nil) {
        self._navigationPath = navigationPath
        self.initialCategory = initialCategory
        self._selectedCategory = State(initialValue: initialCategory)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                        
                        ZStack {
                            VStack {
                                List(contentController.theCloset.clothingCategories, id: \.id) { category in
                                    HStack {
                                        Text(category.title)
                                        Spacer()
                                        Button(action: {
                                            selectCategory(category)
                                        })
                                        {
                                            Image(systemName: selectedCategory == category ? "checkmark.circle.fill" : "circle")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .foregroundColor(selectedCategory == category ? .blue: .gray)
                                    }
                                }
                                Spacer()
                                
                                if selectedImage != nil {
                                    Button("Save to Closet", action: {
                                        guard let selectedCategory = self.selectedCategory,
                                              let selectedImage = self.selectedImage,
                                              let imageURL = contentController.saveImageToDisk(image: selectedImage) else {
                                            return
                                        }
                                        self.contentController.addClothingArticle(category: selectedCategory, imageURL: imageURL)
                                        navigateToCategoryItemDetailView.toggle()
                                        navigationPath = [.categoryItemDetailView(selectedCategory)]
                                        self.selectedImage = nil
                                    })
                                    .padding()
                                    .background(customPink)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(.bottom)
                                    
                                    .sheet(isPresented: $navigateToCategoryItemDetailView) {
                                        CategoryItemDetailView(contentController: contentController, category: selectedCategory!, navigationPath: $navigationPath)
                                    }
                                }
                            }
                        }
                    } else {
                        ZStack {
                            VStack {
                                Spacer()
                                Button(action: {
                                    showingOptions = true
                                }) {
                                    Image("AddToYourCloset")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(20)
                                }
                                
                                .confirmationDialog("Choose Image Source", isPresented: $showingOptions, titleVisibility: .visible) {
                                    Button("Photo Library"){
                                        self.sourceType = .photoLibrary
                                        self.isImagePickerDisplay.toggle()
                                    }
                                    Button("Camera") {
                                        self.sourceType = .camera
                                        self.isImagePickerDisplay.toggle()
                                    }
                                }
                            }
                            .background(
                                Image("AddToMyCloset")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                )
                            
                        }
                    }
                }
                .sheet(isPresented: self.$isImagePickerDisplay) {
                    ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                }
            }
        }
    }
    
    func selectCategory(_ category: ClothingCategory) {
        selectedCategory = category
    }
}

struct InputClothingItemView_Previews: PreviewProvider {
    static var previews: some View {
        InputClothingItemView(navigationPath: .constant([]))
            .environmentObject(ClosetContentController.shared)
    }
}
