//
//  FitCheckInputView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/8/23.


import SwiftUI

struct FitCheckInputView: View {
    
    @State private var fitCheckDate = Date.now
   
    
    @Environment(\.dismiss) var dismiss
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var showingOptions = false
    @State private var navigateToFitCheckList = false
    
    @ObservedObject var contentController: FitCheckContentController
    @Binding var navigationPath: [AppView]
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("FitCheck")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 500, height: 130)
                    VStack {
                        
                        if selectedImage != nil {
                            
                            Button("Save OOTD", action: {
                                print("Save OOTD button tapped")
                                guard let selectedImage = self.selectedImage,
                                      let imageURL = contentController.saveImageToDisk(image: selectedImage) else {
                                    print("Selected image is nil")
                                    return
                                }
                                self.contentController.addFitCheck(imageURL: imageURL, date: fitCheckDate)
                                print("addFitCheck has been called with imageURL: \(imageURL)")
                                self.navigateToFitCheckList = true
                                self.selectedImage = nil
                                
//                                self.eventStore.addOutfitToCalendar(on: fitCheckDate)
                                
                            })
                            NavigationLink("", destination: FitCheckListView(contentController: contentController, navigationPath: $navigationPath, dismissView: dismissView), isActive: $navigateToFitCheckList)
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 300)
                            
                            DatePicker(selection: $fitCheckDate, in: ...Date.now, displayedComponents: .date) {
                                Text("Tell us when you wore this!")
                            }
                        } else {
                            //                            BaseFitCheckInputView()
                            Image("AddToMyCloset")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 400, height: 400)
                            
                            VStack {
                                
                                Button(action: {
                                    showingOptions = true
                                }) {
                                    Image("SnapPicOfFit")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300, height: 150)
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
                        }
                    }
                    .sheet(isPresented: self.$isImagePickerDisplay) {
                        ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                    }
                }
            }
        }
    }
    
    func dismissView() {
        dismiss()
    }
}

struct FitCheckInputView_Previews: PreviewProvider {
    static var previews: some View {
        FitCheckInputView(contentController: FitCheckContentController.shared, navigationPath: .constant([]))
    }
}
