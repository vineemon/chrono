//
//  ContentView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isPopoverPresented = false
    @State private var selection = "Year"
    @State var events: [Event] = []
    let timeOptions = ["Year", "Month", "Day"]
    let date = Date.now
    
    var body: some View {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let timelineGranularity = [
            "Year" : components.year ?? 0,
            "Month" : components.month ?? 0,
            "Day" : components.day ?? 0
        ]
        VStack {
            // buttons to control how many years
            HStack {
                Button(action: addEvent) {
                    Image(systemName: "plus")
                }.buttonStyle(.borderedProminent)
                    .frame(alignment: .bottom).popover(isPresented: $isPopoverPresented) {
                        AddEventView(isPopoverPresented: $isPopoverPresented, events: $events)
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
                    ForEach(0..<20) { x in
                        TimelineView(events: $events, selection: $selection, date: self.date, interval: timelineGranularity[selection]!+x, x: x)
                    }
                }
            }.frame(height: 100)
        }
    }
        
    func addEvent() {
        self.isPopoverPresented = true
    }
}


struct TimelineView: View {
    @Binding var events: [Event]
    @Binding var selection: String
    var date: Date
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
            ForEach(self.events, id:\.self) {event in
                // only add if date is in range
                if (getEventTime(event: event) == interval) {
                    Circle().foregroundColor(.blue).frame(width: 10, height: 10).position(x: (event.date.timeIntervalSince(self.date)/20000) + 20, y: -10).offset(y: -20)
                    Divider().frame(width: 1, height: 20).background(.blue).position(x: (event.date.timeIntervalSince(self.date)/20000) + 20).offset(y: -20)
                }
            }
            HStack(spacing: 0.0) {
                Divider().frame(height: 40).background(.blue).position(x: CGFloat(100*x + 20))
            }.padding(Edge.Set.bottom, -20)
            Text(getIntervalString()).position(x: CGFloat(x*100 + 20), y: 40)
        }.frame(width: 140, height: 70)
    }
    
    func getEventTime(event: Event) -> Int {
        if (selection == "Year") {
            return event.year
        } else if (selection == "Month") {
            return event.month
        } else {
            return event.day
        }
    }
    
    func getIntervalString() -> String {
        if (selection == "Year") {
            return String(interval)
        } else if (selection == "Month") {
            return monthString[interval % 12]!
        } else {
            return String(interval % 31)
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
    let text: String
}
