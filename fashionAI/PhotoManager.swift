//
//  PhotoManager.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/25/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

class PhotoManager: ObservableObject {
    @Published var photos: [UIImage] = []
    @Published var photoPaths: [String] = []
    
    init() {
        retrievePhotos()
    }
    
    func uploadPhoto(_ image: UIImage) {
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn image into data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        // Specify file path and name
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        // Upload data
        fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // Save a reference to the file in Firestore
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url": path]) { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            // Add uploaded image to the list of images for display
                            self.photos.append(image)
                        }
                    }
                }
            }
        }
    }
    
    func retrievePhotos() {
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()
                
                for doc in snapshot!.documents {
                    if let url = doc["url"] as? String {
                        paths.append(url)
                    }
                }
                
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if let data = data, error == nil {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.photos.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deletePhoto(at index: Int) {
        guard index < photoPaths.count else { return }

        let path = photoPaths[index]
        let storageRef = Storage.storage().reference().child(path)
        
        storageRef.delete { error in
            if error == nil {
                let db = Firestore.firestore()
                db.collection("images").whereField("url", isEqualTo: path).getDocuments { snapshot, error in
                    if let snapshot = snapshot {
                        for doc in snapshot.documents {
                            db.collection("images").document(doc.documentID).delete { error in
                                if error == nil {
                                    DispatchQueue.main.async {
                                        if index < self.photos.count && index < self.photoPaths.count {
                                            self.photos.remove(at: index)
                                            self.photoPaths.remove(at: index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
