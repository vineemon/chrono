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
    @State var text = ""
    @State var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        
        VStack {
            
            PhotosPicker(selection: $selectedItems,
                         matching: .images) {
                Text("Choose your favorite pictures from the event.")
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
            

            
            Button(action: submitEvent) {
                Text("Submit")
            }.buttonStyle(.borderedProminent)
                .frame(alignment: .bottom)
        }.padding()
    }
    
    
    func submitEvent() {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        self.events.append(Event(date: date, year: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0, hour: components.hour ?? 0, text: text))
        self.isPopoverPresented = false
    }
}

//struct AddEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEventView()
//    }
//}
