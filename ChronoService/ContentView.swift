//
//  ContentView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/10/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    init() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .systemBlue
            UIPageControl.appearance().pageIndicatorTintColor = .gray
            UIPageControl.appearance().tintColor = .gray
        }
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var isPopoverPresented = false
    @State var eventsList: [[Event]] = [[],[],[]]
    @State var timelineNames: [String] = ["Priyanka & Me", "Dosa & Me", "Aneet & Me"]
    @State var timelineColors: [Color] = [.blue, .red, .green]
    @State var isEditTimelinesActive = false
    @State var username = "test@gmail.com"
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Chrono").font(.system(size: 24)).bold()
                    Spacer()
                    Menu {
                        Button {
                            self.isEditTimelinesActive = true
                        } label: {
                            Label("Edit Timelines", systemImage: "plus.square.fill.on.square.fill")
                        }
                        Button {
                            self.isEditTimelinesActive = true
                        } label: {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        Button {
                            self.isEditTimelinesActive = true
                        } label: {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right.fill")
                        }
                    } label: {
                        Label("", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }.padding()
            HStack {
                TabView {
                    ForEach(0..<firestoreManager.events.count, id:\.self) {i in
                        Text("My restaurant: \(firestoreManager.events[i].title)")
                        VStack {
                            HStack {
                                Text(timelineNames[i]).font(.system(size: 24)).bold().foregroundColor(.blue)
                                Button(action: addEvent) {
                                    Image(systemName: "plus")
                                }.buttonStyle(.borderedProminent)
                                    .popover(isPresented: $isPopoverPresented) {
                                        AddEventView(isPopoverPresented: $isPopoverPresented, events: $eventsList[i], username: $username).environmentObject(firestoreManager)
                                    }
                            }.padding()
                            ScrollView(.vertical) {
                                HStack() {
                                    VStack{
                                        EventScrollView(events: $eventsList[i])
                                        Spacer()
                                    }.frame(width: 300)
                                    Divider().frame(width: 1, height: 200 * CGFloat(eventsList[i].count + 3)).overlay(timelineColors[i])
                                }
                            }
                        }
                    }
                }.tabViewStyle(.page)
            }.navigationDestination(isPresented: $isEditTimelinesActive) {
                EditTimelinesView()
            }
        }
    }
        
    func addEvent() {
        self.isPopoverPresented = true
    }
}

struct EventScrollView : View {
    @Binding var events: [Event]
    
    var body: some View {
        ForEach(0..<events.count, id:\.self) {i in
            // if new year, add horizontal divider
            if (i == 0) {
                NewDateView(event: events[i])
            } else if (events[i - 1].year != events[i].year || events[i - 1].month != events[i].month) {
                NewDateView(event: events[i])
            }
            NewEventView(events: $events, i: i)
        }
    }
}

struct NewEventView: View {
    @Binding var events: [Event]
    var i: Int

    var body: some View {
        HStack {
            if let unwrappedImage = events[i].eventImage {
                Button(action: { showEventDetails(i: i) }) {
                    unwrappedImage
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .frame(width: 300, height: 200)
                }.popover(isPresented: $events[i].showEvents) {
                    ShowEventView(event: $events[i])
                }
            }
        }
    }
    func showEventDetails(i: Int) {
        self.events[i].showEvents = true
    }
}

struct NewDateView: View {
    var event: Event
    
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
        HStack {
            VStack {
                Divider().frame(width: 100).background(.blue)
            }
            Text(monthString[event.month  - 1]! + " " + String(event.year))
            VStack {
                Divider().frame(width: 100).background(.blue)
            }
        }
    }
}

struct Event {
    let date: Date
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let text: String
    let title: String
    let photo: PhotosPickerItem?
    var eventImage: Image?
    var showEvents: Bool
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirestoreManager())
    }
}
