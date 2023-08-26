//
//  FirestoreManager.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/25/23.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import PhotosUI

class FirestoreManager: ObservableObject {
    @Published var timelines: [Timeline] = []
    @Published var images: [[EventPic]] = [[]]
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        let db = Firestore.firestore()
        let storage = Storage.storage()
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
        // TODO: loop through events and download photos
        var i = 0
        for timeline in timelines {
            var j = 0
            self.images.append([])
            for event in timeline.events  {
                self.images[i].append(EventPic())
                // Create a reference to the file you want to download
                let storageRef = storage.reference().child(event.imageUrl)
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                    // Uh-oh, an error occurred!
                  } else {
                    // Data for image is returned
                      self.images[i][j].eventImage = UIImage(data: data!)
                  }
                }
                j += 1
            }
            i += 1
        }
                
    }
    
    func upload(image: UIImage) -> String {
        let storage = Storage.storage()
        // Create a storage reference\
        let path = "images/\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child(path)
//
//        // Resize the image to 200px with a custom extension
//        let resizedImage = image..aspectFittedToHeight(200)

        // Convert the image into JPEG and compress the quality to reduce its size
        let data = image.jpegData(compressionQuality: 0.2)

        // Upload the file to the path "images/rivers.jpg"
        _ = storageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil && metadata == nil {
            // Uh-oh, an error occurred!
            return
          }
        }
        return path
    }
    
    func updateEvents(timelines: [Timeline], user: String) {
        let locEvents = Timelines(username: user, timelines: timelines)
        let db = Firestore.firestore()
        let storage = Storage.storage()
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
