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

    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            ContentView(timelines: $firestoreManager.timelines).environmentObject(firestoreManager)
        }
    }
}
