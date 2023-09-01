//
//  FitCheckCalendarView.swift
//  FitCheckPersonalCapstone
//
//  Created by Paige Stephenson on 9/1/23.
//

import SwiftUI

struct FitCheckCalendarView: View {

    @ObservedObject var fitCheckContentController = FitCheckContentController.shared
    @State private var currentDate = Date.now
    @State private var OOTD: OOTD?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                DatePicker("", selection: $currentDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                if let OOTD,
                   let imageData = try? Data(contentsOf: URL(string: OOTD.imagePath())!),
                   let img = UIImage(data: imageData) {
                       
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("You haven't added an outfit to this day yet.")
                }
            }
            .onChange(of: currentDate) { newValue in
                OOTD = fitCheckContentController.getOOTD(date: newValue)
            }
        }
    }
}
struct FitCheckCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        FitCheckCalendarView()
    }
}
