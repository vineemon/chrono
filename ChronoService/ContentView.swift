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
    @State var eventImages: [Image?] = []
    @State var events: [Event] = []
    @State var shownEvent: Event = Event(date: Date.now, year: 0, month: 0, day: 0, hour: 0, text: "", title: "", photo: nil)
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
                        AddEventView(isPopoverPresented: $isPopoverPresented, events: $events, showEvents: $showEvents, eventImages: $eventImages)
                    }
                
                // dropdown to control timeline view
                Picker("Select a timeline view", selection: $selection) {
                    ForEach(timeOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
            
            ScrollView(.vertical) {
                    HStack() {
                        VStack{
                            ForEach(0..<events.count, id:\.self) {i in
                                // if new year, add horizontal divider
                                if (i == 0) {
                                    NewDateView(event: events[i])
                                } else if (events[i - 1].year != events[i].year) {
                                    NewDateView(event: events[i])
                                }
                                HStack {
                                    if let unwrappedImage = eventImages[i] {
                                        Button(action: { showEventDetails(event: events[i], i: i) }) {
                                            unwrappedImage
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(10)
                                                .shadow(radius: 10)
                                                .frame(width: 300, height: 200)
                                        }.popover(isPresented: $showEvents[i]) {
                                            ShowEventView(isPopoverPresented: $showEvents[i], event: $shownEvent)
                                        }
                                    }
                                }.task {
                                    if let data = try? await events[i].photo?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            eventImages[i] = Image(uiImage: uiImage)
                                            return
                                        }
                                    }
                                }
                            }
                        }.frame(width: 300)
                        Divider().background(.blue).frame(height: 1000)
                    }
            }.padding()
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

struct NewDateView: View {
    var event: Event

    var body: some View {
        HStack {
            Text(String(event.year))
            VStack {
                Divider().frame(width: 250).background(.blue)
            }
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
        HStack() {
            Text(getIntervalString()).position(y: CGFloat(100*x + 1000))
            VStack(spacing: 0.0) {
                Divider().frame(width: 200).background(.blue).position(x: 50, y: CGFloat(100*x + 1000))
            }.padding(Edge.Set.trailing, -20)
        }.frame(width: 200, height: 140)
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
    let title: String
    let photo: PhotosPickerItem?
}
