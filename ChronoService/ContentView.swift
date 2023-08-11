//
//  ContentView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/10/23.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
            HStack {
                Button {

                } label: {
                        Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
                Text("Add your plans to the timeline!")
            }
            HStack {
                // 1
                Circle()
                .fill(Color.gray)
                .frame(width: 10, height: 10)
                // 2
                Circle()
                .fill(Color.gray)
                .frame(width: 10, height: 10)
                // 3
                Circle()
                .fill(Color.gray)
                .frame(width: 10, height: 10)
            }.padding(Edge.Set.leading, -155).padding(Edge.Set.bottom, -10)
            HStack {
                // 1
                Divider().frame(height: 20)
                // 2
                Divider().frame(height: 20).padding(Edge.Set.leading, 10)
                // 3
                Divider().frame(height: 20).padding(Edge.Set.leading, 10)
            }.padding(Edge.Set.bottom, -10.65).padding(Edge.Set.leading, -150)
            
            Divider().background(.gray)
        }
        .padding()
    }
    
    
//    func greeting() {
//
//            print("Hello, World!")
//        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
