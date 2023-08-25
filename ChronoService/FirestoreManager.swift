//
//  FirestoreManager.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/25/23.
//

import Firebase

class FirestoreManager: ObservableObject {
    @Published var events: [Event] = []
    
    init() {
        fetchEvents()
    }

    func fetchEvents() {
        let db = Firestore.firestore()

        let docRef = db.collection("Events").document("test@gmail.com")

        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    self.events = data["events"] as? [Event] ?? []
                }
            }

        }
    }
    
    func createEvents(events: [Event], user: String) {
        let db = Firestore.firestore()

        let docRef = db.collection("Events").document(user)

        docRef.setData(["events": convertEventsToDic(events: events)]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateEvents(events: [Event], user: String) {
        let db = Firestore.firestore()

        let docRef = db.collection("Events").document(user)

        // Don't forget the **merge: true** before closing the parentheses!
        docRef.setData(["events": convertEventsToDic(events: events)], merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully merged!")
            }
        }
    }
    
    private func convertEventsToDic(events: [Event]) -> [Any]{
        var newEvents = [Any]()
        
        for event in events {
            newEvents.append([
                "date": event.date,
                "year": event.year,
                "month": event.month,
                "day": event.day,
                "hour": event.hour,
                "text": event.text,
                "title": event.title,
                "showEvents": event.showEvents,
            ])
        }
        return newEvents
    }
//
//    private func convertDicToEvents(dict: [Any]) -> [[Event]]{
//        var newEvents = [Event]()
//
//        for event in dict {
//            newEvents.append(Event(date: event["date"] as? Date ?? Date.now, year: event["year"] as Int, month: event["month"] as Int, day: event["day"] as Int, hour: event["hour"] as Int, text: event["text"] as String, title: event["title"] as String, photo: nil, eventImage: nil, showEvents: event["showEvents"] as Bool))
//        }
//        return [newEvents]
//    }
}
