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
            
            HStack{
                DatePicker(
                    "Event Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
            }
            HStack{
                Text("Description:")
                TextField("We were able to go so much", text: $text)
            }
        
            PhotosPicker(selection: $selectedItems,
                         matching: .images) {
                Text("Choose your favorite pictures from the event.")
            }
            

            
            Button(action: submitEvent) {
                Text("Submit")
            }.buttonStyle(.borderedProminent)
                .frame(alignment: .bottom)
        }
    }
    
    
    func submitEvent() {
        self.events.append(Event(date: date, text: text))
        self.isPopoverPresented = false
    }
}

//struct AddEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEventView()
//    }
//}
