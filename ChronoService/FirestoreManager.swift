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
import SwiftUI

class FirestoreManager: ObservableObject {
    @Published var timelines: [Timeline] = []
    @Published var images: [[EventPic]] = [[]]
    
    func fetchEvents(username: String) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let docRef = db.collection("Timelines").document(username.lowercased())

        docRef.getDocument { document, error in
            if error == nil && document != nil {
                do {
                    self.timelines = try document!.data(as: Timelines.self).timelines
                    for i in 0..<self.timelines.count {
                        self.images.insert([], at: i)
                        for j in 0..<self.timelines[i].events.count  {
                            self.images[i].insert(EventPic(), at: j)
                            // Create a reference to the file you want to download
                            let storageRef = storage.reference().child(self.timelines[i].events[j].imageUrl)
                            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                if error != nil && data == nil {
                                    print("Error occurred!!")
                                } else {
                                    // Data for image is returned
                                    self.images[i][j].eventImage = UIImage(data: data!)
                                }
                            }
                        }
                    }
                } catch {
                    print("Error occurred!!")
                }
            }
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
        let db = Firestore.firestore()
        let docRef = db.collection("Timelines").document(user)
        do {
            try docRef.setData(from: Timelines(username: user.lowercased(), timelines: timelines))
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
