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
    
    var body: some View {
        VStack {
            Text("Title: " + event.title).bold()
            if let unwrappedImage = eventPic.eventImage {
                Image(uiImage: unwrappedImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(width: 300, height: 300)
            }
            Text("Description: " + event.text)
        }.padding()
    }
}
