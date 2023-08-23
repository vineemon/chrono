//
//  AddEventView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/11/23.
//

import SwiftUI
import PhotosUI

struct AddEventView: View {
    @Binding var isPopoverPresented: Bool
    @Binding var events: [Event]
    
    @State var date = Date()
    @State var title = ""
    @State var text = ""
    @State var photo: PhotosPickerItem?
    @State var image: Image?
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Title:")
                TextField("Dog Day!", text: $title)
            }
            HStack{
                DatePicker(
                    "Event Date:",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            HStack{
                Text("Description:")
                TextField("Today, I got a dog!", text: $text)
            }
            
            PhotosPicker(selection: $photo,
                         matching: .images) {
                Text("Photos:")
            }.frame(maxWidth: .infinity, alignment: .leading).onChange(of: photo)
            { _ in
                Task {
                    if let data = try? await photo.unsafelyUnwrapped.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            image = Image(uiImage: uiImage)
                            return
                        }
                    }
                }
            }
            

            
            Button(action: submitEvent) {
                Text("Submit")
            }.buttonStyle(.borderedProminent)
                .frame(alignment: .bottom)
        }.padding()
    }
    
    
    func submitEvent() {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        self.events.append(Event(date: date, year: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0, hour: components.hour ?? 0, text: text, title: title, photo: photo, eventImage: image, showEvents: false))
        self.events.sort{$0.date < $1.date}
        self.isPopoverPresented = false
    }
}
