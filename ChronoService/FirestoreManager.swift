//
//  FirestoreManager.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/25/23.
//

import Firebase
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    @Published var timelines: [Timeline] = []
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        let db = Firestore.firestore()
      let docRef = db.collection("Timelines").document("test@gmail.com")

      docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        }
        else {
          if let document = document {
            do {
                self.timelines = try document.data(as: Timelines.self).timelines
            }
            catch {
              print(error)
            }
          }
        }
      }
    }
    
    func updateEvents(timelines: [Timeline], user: String) {
        let locEvents = Timelines(username: user, timelines: timelines)
        let db = Firestore.firestore()
        let docRef = db.collection("Timelines").document(user)
        do {
          try docRef.setData(from: locEvents)
        }
        catch {
          print(error)
        }
    }

}

struct Timelines: Codable {
  @DocumentID var username: String?
  var timelines: [Timeline]
}
