//
//  ChronoServiceApp.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/10/23.
//

import SwiftUI
import Firebase

@main
struct ChronoServiceApp: App {
    @StateObject var firestoreManager = FirestoreManager()
    
//    @State var timelines: [Timeline] = [Timeline(name: "Priyanka & Me", events: []), Timeline(name: "Dosa & Me", events: []), Timeline(name: "Aneet & Me", events: [])]
//    @State var eventsPicsList: [[EventPic]] = [[EventPic()],[EventPic()],[]]

    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            LoginView().environmentObject(firestoreManager)
        }
    }
}
