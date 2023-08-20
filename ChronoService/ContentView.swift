//
//  ContentView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/10/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var isPopoverPresented = false
    @State private var selection = "Year"
    @State var events: [Event] = []
    @State var shownEvent: Event = Event(date: Date.now, year: 0, month: 0, day: 0, hour: 0, text: "", photo: nil)
    @State var showEvents: [Bool] = []
    let timeOptions = ["Year", "Month", "Day"]
    let date = Date.now
    let timelineGranularity = [
        "Year" : Calendar.current.dateComponents([.year], from: Date.now).year! - 3,
        "Month" : 0,
        "Day" : 0
    ]
    
    var body: some View {
        VStack {
            // buttons to control how many years
            HStack {
                Button(action: addEvent) {
                    Image(systemName: "plus")
                }.buttonStyle(.borderedProminent)
                    .frame(alignment: .bottom).popover(isPresented: $isPopoverPresented) {
                        AddEventView(isPopoverPresented: $isPopoverPresented, events: $events, showEvents: $showEvents)
                    }
                
                // dropdown to control timeline view
                Picker("Select a timeline view", selection: $selection) {
                    ForEach(timeOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
            List {
                Section {
                    ForEach(self.events, id:\.self){ event in
                        Text("\(event.date.formatted()): \(event.text)")
                    }
                } header: {
                    Text("Chrono Events")
                }
            }.listStyle(.insetGrouped).padding(.bottom, 20).scrollContentBackground(.hidden)
            ScrollView(.horizontal) {
                Divider().background(.blue).frame(height: 1).padding(.top, 40)
                HStack() {
                    ZStack() {
                        ForEach(0..<events.count, id:\.self) {i in
                            Button(action: { showEventDetails(event: events[i], i: i) }) {
                                        Text("")
                                            .frame(width: 10, height: 10)
                                            .background(.blue)
                                            .clipShape(Circle())
                            }.position(x: CGFloat(getEventTimeDifference(event: events[i]) + 20)).offset(y: -30).popover(isPresented: $showEvents[i]) {
                                ShowEventView(isPopoverPresented: $showEvents[i], event: $shownEvent)
                            }
                            Divider().frame(width: 1, height: 20).background(.blue).position(x: CGFloat(getEventTimeDifference(event: events[i]) + 20)).offset(y: -20)
                        }
                    }
                    ForEach(0..<20) { x in
                        TimelineView(selection: $selection, interval: timelineGranularity[selection]!+x, x: x)
                    }
                }
            }.frame(height: 100)
        }
    }
        
    func addEvent() {
        self.isPopoverPresented = true
    }
    
    func showEventDetails(event: Event, i: Int) {
        self.shownEvent = event
        self.showEvents[i] = true
    }
    
    func getEventTimeDifference(event: Event) -> Int {
        if (selection == "Year") {
            return 20 * event.month + 240 * (event.year - 2020)
        } else if (selection == "Month") {
            return 2 * (event.day - 1) + 240 * event.month
        } else {
            return 10 * event.hour + 240 * (event.day - 1)
        }
    }
}


struct TimelineView: View {
    @Binding var selection: String
    var interval: Int
    var x: Int
    
    let monthString = [
        0 : "Jan",
        1 : "Feb",
        2 : "Mar",
        3 : "Apr",
        4 : "May",
        5 : "Jun",
        6 : "Jul",
        7 : "Aug",
        8 : "Sep",
        9 : "Oct",
        10 : "Nov",
        11 : "Dec",
    ]
    
    var body: some View {
        ZStack() {
            HStack(spacing: 0.0) {
                Divider().frame(height: 40).background(.blue).position(x: CGFloat(100*x + 20))
            }.padding(Edge.Set.bottom, -20)
            Text(getIntervalString()).position(x: CGFloat(x*100 + 20), y: 40)
        }.frame(width: 140, height: 70)
    }
    
    func getIntervalString() -> String {
        if (selection == "Year") {
            return String(interval)
        } else if (selection == "Month") {
            return monthString[interval % 12]!
        } else {
            return String(interval % 31 + 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Event: Hashable {
    let date: Date
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let text: String
    let photo: PhotosPickerItem?
}
