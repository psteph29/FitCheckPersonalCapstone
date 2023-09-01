//
//  ContentView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 7/27/23.
//

import SwiftUI

enum AppView: Codable, Hashable {
    case inputClothingView(ClothingCategory)
    case categoryView
    case carouselView
    case categoryItemDetailView(ClothingCategory)
    case fitCheckInputView
    case fitCheckListView
    case fitCheckDetailView(OOTD)
}

struct ContentView: View {
    
    @StateObject var contentController = ClosetContentController.shared
    @StateObject var fitCheckContentController = FitCheckContentController.shared
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    @State var navigationPath: [AppView] = []
    
    @State private var isShowing = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView {
                ClothingCategoryView(navigationPath: $navigationPath)
                    .tabItem {
                        Image(systemName: "tshirt")
                        Text("My Closet")
                    }
//                FitCheckInputView(contentController: fitCheckContentController, navigationPath: $navigationPath, isShowing: $is)
//                    .tabItem {
//                        Image(systemName: "3.circle")
//                        Text("New Fit Check")
//                    }
                FitCheckListView(contentController: fitCheckContentController, navigationPath: $navigationPath)
                    .tabItem {
                        Image(systemName: "figure.stand")
                        Text("OOTD")
                    }
                FitCheckCalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                CarouselView()
                    .tabItem {
                        Text("CarouselView")
                    }
                
            }
            .navigationDestination(for: AppView.self) { appView in
                switch appView {
                case .categoryView:
                    ClothingCategoryView(navigationPath: $navigationPath)
                case .carouselView:
                    CarouselView()
                case .inputClothingView(let category):
                    InputClothingItemView(navigationPath: $navigationPath, initialCategory: category)
                case .categoryItemDetailView(let category):
                    CategoryItemDetailView(contentController: contentController, category: category, navigationPath: $navigationPath)
                case .fitCheckListView:
                    FitCheckListView(contentController: fitCheckContentController, navigationPath: $navigationPath)
                case.fitCheckInputView:
                    FitCheckInputView(contentController: fitCheckContentController, navigationPath: $navigationPath, isShowing: $isShowing)
                case .fitCheckDetailView(let ootd):
                    FitCheckDetailView(ootd: ootd)
                }
            }
            .environmentObject(contentController)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

