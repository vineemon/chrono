//
//  ShowEventView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/20/23.
//

import SwiftUI
import PhotosUI

struct ShowEventView: View {
    @Binding var isPopoverPresented: Bool
    @Binding var event: Event
    
    @State var date = Date()
    @State var text = ""
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        VStack {
            Text(event.text)
//            HStack{
//                if let selectedImageData,
//                   let uiImage = UIImage(data: selectedImageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 250, height: 250)
//                }
//            }.onAppear {
//                // Retrieve selected asset in the form of Data
//                if let data = try? await event.photo?.loadTransferable(type: Data.self) {
//                    selectedImageData = data
//                }
//            }
        }.padding()
    }
}
