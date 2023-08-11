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
    let timeOptions = ["Year", "Month", "Day"]

    var body: some View {
        VStack {
            // buttons to control how many years
            HStack {
                Button(action: addEvent) {
                    Image(systemName: "plus")
                }.buttonStyle(.borderedProminent)
                    .frame(alignment: .bottom).popover(isPresented: $isPopoverPresented) {
                        AddEventView()
                    }
                
                // dropdown to control timeline view
                Picker("Select a timeline view", selection: $selection) {
                                ForEach(timeOptions, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
            }.padding(Edge.Set.bottom, 500)
            
            // circles for event pictures
            HStack {
                // 1
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .frame(width: 10, height: 10).offset(x: 50, y: 12)
                // 2
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .frame(width: 10, height: 10).offset(x:64, y: 12)
                // 3
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .frame(width: 10, height: 10).offset(x: 75, y: 12)
            }.padding(Edge.Set.leading, -155).padding(Edge.Set.bottom, -10)
            
            // ticks for events and years
            HStack(alignment: .bottom, spacing: 10) {
                // year beginning
                Divider().frame(height: 40).background(.blue).offset(x: 0).padding(Edge.Set.bottom, -20)
                // 1
                Divider().frame(height: 20).background(.blue).offset(x: 40).padding(Edge.Set.bottom, -10)
                // 2
                Divider().frame(height: 20).background(.blue).offset(x: 60).padding(Edge.Set.bottom, -10)
                // 3
                Divider().frame(height: 20).background(.blue).offset(x: 80).padding(Edge.Set.bottom, -10)
                
                // year middle
                Divider().frame(height: 40).background(.blue).offset(x: 100).padding(Edge.Set.bottom, -20)
                
                // year end
                Divider().frame(height: 40).background(.blue).offset(x: 230).padding(Edge.Set.bottom, -20)
                
            }.padding(Edge.Set.leading, -150)
            
            Divider().background(.blue)
            
            
            // years
            HStack(alignment: .top, spacing: 10) {
                // year beginning
                Text("2023").offset(x: -10)
                // 2
                Text("2024").padding(Edge.Set.leading, 10).offset(x: 65)
                // year end
                Text("2025").padding(Edge.Set.leading, 10).offset(x: 150)
            }.padding(Edge.Set.bottom, -13).padding(Edge.Set.leading, -150).padding(Edge.Set.top, 13)
        }
        .padding()
    }
    
    func addEvent() {
        self.isPopoverPresented = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ButrtonView: View {
    var body: some View {
        Image(systemName: "plus")
    }
}
