//
//  ShowEventView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/20/23.
//

import SwiftUI
import PhotosUI

struct ShowEventView: View {
    @Binding var event: Event
    @Binding var eventPic: EventPic
    
    @State private var eventImage: Image?
    
    var body: some View {
        VStack {
            Text("Title: " + event.title).bold()
            if let eventImage {
                eventImage
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(width: 300, height: 300)
            }
            Text("Description: " + event.text)
        }.task {
            if let data = try? await eventPic.photo?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    eventImage = Image(uiImage: uiImage)
                    return
                }
            }
        }.padding()
    }
}
