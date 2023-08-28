//
//  CreateTimelineView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/24/23.
//

import SwiftUI

struct CreateTimelineView: View {
    
    @Binding var timelines: [Timeline]
    @Binding var eventsPicsList: [[EventPic]]
    @State var title = ""
    @State var isContentViewActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Timeline Name")
                    TextField("Robert", text: $title)
                }
                
                Button(action: submitTimeline) {
                    Text("Submit")
                }.buttonStyle(.borderedProminent)
                    .frame(alignment: .bottom)
            }.padding()
            .navigationTitle("Create Timeline")
            .navigationDestination(isPresented: $isContentViewActive) {
                ContentView(timelines: $timelines, eventsPicsList: $eventsPicsList)
            }
        }
    }
    
    func submitTimeline() {
        self.timelines.append(Timeline(name: title, events: []))
        self.isContentViewActive = true
    }
}

//struct CreateTimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateTimelineView()
//    }
//}
