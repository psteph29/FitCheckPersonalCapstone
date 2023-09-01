//
//  Coordinator.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 7/27/23.
//

import Foundation


import Foundation
import UIKit


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePicker
    
    init(picker: ImagePicker) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}
