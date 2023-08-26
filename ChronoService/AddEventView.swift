//
//  AddEventView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/11/23.
//

import SwiftUI
import PhotosUI

struct AddEventView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var isPopoverPresented: Bool
    @Binding var timelines: [Timeline]
    @Binding var eventsPics: [EventPic]
    @Binding var username: String
    var i: Int
    
    @State var date = Date()
    @State var title = ""
    @State var text = ""
    @State var photo: PhotosPickerItem?
    @State var image: UIImage?
    
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
                            image = uiImage
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
        let url = firestoreManager.upload(image: image!)
        let newEvent = Event(date: date, year: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0, hour: components.hour ?? 0, text: text, title: title, showEvents: false, imageUrl: url)
        let index = self.timelines[i].events.insertionIndexOf(newEvent) { $0.date < $1.date }
        self.timelines[i].events.insert(newEvent, at: index)
        self.eventsPics.insert(EventPic(eventImage: image), at: index)
        firestoreManager.updateEvents(timelines: self.timelines, user: username)
        
        self.isPopoverPresented = false
    }
}

extension Array {
    func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}
