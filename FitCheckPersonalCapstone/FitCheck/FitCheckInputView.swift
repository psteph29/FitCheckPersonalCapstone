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
    @Binding var isShowing: Bool
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("FitCheck")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 500, height: 130)
                    VStack(spacing: 20) {
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 200)
                            Spacer()
                            
                            DatePicker(selection: $fitCheckDate, in: ...Date.now, displayedComponents: .date) {
                                
                                Image("TellUsWhenYouWoreThis")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .padding(20)
                            Button(action: {
                                print("Save OOTD button tapped")
                                guard let selectedImage = self.selectedImage,
                                      let imageURL = contentController.saveImageToDisk(image: selectedImage) else {
                                    print("Selected image is nil")
                                    return
                                }
                                self.contentController.addFitCheck(imageURL: imageURL, date: fitCheckDate)
                                print("addFitCheck has been called with imageURL: \(imageURL)")
                                self.isShowing = false
                                self.selectedImage = nil
                            }) {
                                Image("ShareOOTD")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 150)
                            }
                            
                        } else {
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

//struct FitCheckInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        FitCheckInputView(contentController: FitCheckContentController.shared, navigationPath: .constant([]))
//    }
//}
