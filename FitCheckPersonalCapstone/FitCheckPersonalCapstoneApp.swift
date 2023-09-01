//
//  FitCheckPersonalCapstoneApp.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 7/27/23.
//

import SwiftUI

@main
struct PersonalCapstoneClosetAppApp: App {
    
    var contentController = ClosetContentController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contentController)
        }
    }
}
