//
//  FitCheckDetailView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 8/23/23.
//

import SwiftUI
import UIKit

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {
    }
}

struct FitCheckDetailView: View {
    
    let imageNames = ["Bold", "Breathtaking", "Cute", "Elegant", "FashionForward", "Fashionista", "Gorgeous", "HipFit", "Lovely", "Perfect", "Slay", "Stunning", "Stylin"]
    
    @State var selectedImage: String = ""
    
    @State var ootd: OOTD
    
    @State var showShareSheet = false
    @State var showTellWhatYouWoreSheet = false
    
    @State var listOfArticlesChosen: [ClothingArticle]
    
    @ObservedObject var contentController: FitCheckContentController
//    The object holding the clothing items worn data
    
    var image: UIImage {
        let data = try? Data(contentsOf: URL(string: ootd.imagePath())!)
        guard let data = data else { return UIImage() }
        return UIImage(data: data) ?? UIImage()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 100)
                    .onAppear {
                        if let randomImage = imageNames.randomElement() {
                            selectedImage = randomImage
                        }
                    }
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 500)
                
                Spacer()
                
                Button(action: {
                    self.showShareSheet = true
                }) {
                    Image("PurpleShare")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    //                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(20)
                        .frame(width: 200, height: 100)
                }
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            if !listOfArticlesChosen.isEmpty {
                                ForEach(listOfArticlesChosen) { article in
                                    CardView(imageName: article.imagePath())
                                }
                                
                            }  else {
                                Button(action: {
                                    self.showTellWhatYouWoreSheet = true
                                }) {
                                    Image("TellUsWhatYouWore")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300, height: 150)
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            .sheet(isPresented: $showShareSheet, content: {
                ActivityViewController(activityItems: [self.image], applicationActivities: nil)
            })
            .sheet(isPresented: $showTellWhatYouWoreSheet) {
                
                CarouselView(ShowTellWhatYouWoreIsPresented: $showTellWhatYouWoreSheet, listOfArticlesChosen: $listOfArticlesChosen)
            }
        }
    }
}

// Uncomment and modify this section to include a preview
//struct FitCheckDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FitCheckDetailView(ootd: <#T##OOTD#>)
//    }
//}
