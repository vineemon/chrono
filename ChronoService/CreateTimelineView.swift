//
//  CreateTimelineView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/24/23.
//

import SwiftUI

struct CreateTimelineView: View {
    
    @State var date = Date()
    @State var title = ""
    @State var text = ""
    
    var body: some View {
        VStack {
            HStack{
                Text("Timeline Name")
                TextField("Priyanka & Me", text: $title)
            }
            HStack{
                Text("Timeline Color")
                TextField("Red", text: $text)
            }
            

            
            Button(action: submitTimeline) {
                Text("Submit")
            }.buttonStyle(.borderedProminent)
                .frame(alignment: .bottom)
        }.padding()
    }
    
    func submitTimeline() {
//        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
//        self.events.append(Event(date: date, year: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0, hour: components.hour ?? 0, text: text, title: title, photo: photo, eventImage: image, showEvents: false))
//        self.events.sort{$0.date < $1.date}
//        self.isPopoverPresented = false
    }
}

struct CreateTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTimelineView()
    }
}
