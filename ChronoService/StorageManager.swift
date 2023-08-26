//
//  StorageManager.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/26/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

public class StorageManager: ObservableObject {
    let storage = Storage.storage()

    func upload(image: UIImage) -> String {
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

    func deleteItem(item: StorageReference) {
        item.delete { error in
            if let error = error {
                print("Error deleting item", error)
            }
        }
    }
    
    func download() {
        // get reference from db
        
        // Create a reference to the file you want to download
        let islandRef = storage.reference().child("images/island.jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
          }
        }
    }
}
