//
//  ClothingCategoryView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 7/28/23.
//


import SwiftUI

struct ClothingCategoryView: View {
    
    @State var isShowingImagePicker = false
    @Binding var navigationPath: [AppView]
    
    @State private var showingAlert = false
    @State private var category = ""

    @State private var selection = "Add to closet"
    let options = ["Add a category", "Add a clothing item"]
    
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var contentController: ClosetContentController
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(contentController.theCloset.clothingCategories, id: \.self) { category in
                        NavigationLink(destination: destinationView(for: category)) {
                            HStack {
                                AsyncImage(url: URL(string: category.imageName)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image("ImagePlaceholder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(12)
                                .padding(.trailing, 10)
                                Text(category.title)
                                    .font(.title)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                
            }
            .sheet(isPresented: $isShowingImagePicker, content: {
                InputClothingItemView(navigationPath: $navigationPath)
            })
        }
            .navigationTitle("Closet Categories")
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Menu {
                                    ForEach(options, id: \.self) { option in
                                        Button(option, action: {
                                            handleSelection(option)
                                        })
                                    }
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
            }
            .alert("Create a new category", isPresented: $showingAlert) {
                TextField("e.g. Blouses", text: $category)
                Button("Add to closet", action: submit)
                Button("Cancel", action: cancel)
            } message: {
                Text("Add to your closet")
            }
            .onChange(of: showingAlert) { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
                    }
                }
            }
        }
    }
    
    func submit() {
      let newCategory = ClothingCategory(title: category)
        contentController.theCloset.clothingCategories.append(newCategory)
        category = ""
    }
    
    func cancel() {
        showingAlert = false
    }
    
    func handleSelection(_ option: String) {
        switch option {
        case "Add a category":
            showingAlert = true
        case "Add a clothing item":
            isShowingImagePicker = true
        default:
            break
        }
    }
    
    private func delete(at offsets: IndexSet) {
        contentController.theCloset.clothingCategories.remove(atOffsets: offsets)
    }
    
    private func destinationView(for category: ClothingCategory) -> CategoryItemDetailView {
        switch category.title {
        case "Tees": return  CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Blouses": return CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Dresses": return CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Jackets": return
            CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Jewelry": return CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Pants": return
           CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Shirts": return
            CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Shoes": return CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Shorts": return CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        case "Sweaters": return CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        default:
            return CategoryItemDetailView(contentController: .shared, category: category, navigationPath: $navigationPath)
        }
    }
}

struct ClothingCategory_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ClothingCategoryView(navigationPath: .constant([]))
        }
    }
}
