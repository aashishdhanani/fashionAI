//
//  Camera.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/23/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct Camera: View {
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State var retrievedImages = [UIImage]()
    
    @State private var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: image ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 300)
                
                Button("choose picture") {
                    self.showSheet = true
                }.padding()
                    .actionSheet(isPresented: $showSheet, content: {
                        ActionSheet(title: Text("Select Photo"),
                                    message: Text("Choose"), buttons: [
                                        .default(Text("Photo Library")) {
                                            self.showImagePicker = true
                                            self.sourceType = .photoLibrary
                                        },
                                        .default(Text("Camera")) {
                                            self.showImagePicker = true
                                            self.sourceType = .camera
                                        },
                                        .cancel()
                                    ])
                    }
                    )
               //upload button
                if image != nil {
                    Button {
                        uploadPhoto()
                    }label : {
                        Text("upload photo")
                    }
                }
                
                Divider()
                
                HStack {
                    
                    //loop through the images and display them
                    ForEach(retrievedImages, id: \.self) {
                        image in Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    
                    
                }
            }
            
            .navigationTitle("Camera")
            
        }.sheet(isPresented: $showImagePicker, content: {
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        })
        .onAppear {
            retrievePhotos()
        }
    }
    func uploadPhoto() {
        //make sure that the image is not nil
        guard image != nil else {
            return
        }
        //create storage reference
        let storageRef = Storage.storage().reference()
        
        //turn image into data
        let imageData = image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        //specify file path and name
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        //upload data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            
            if error == nil && metadata != nil {
                //save a reference to the file in Firestore
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url": path]) { error in
                    //if there were no errors, display
                    if error == nil {
                        DispatchQueue.main.async {
                            //add uploaded image to the list of images for dispkay
                            self.retrievedImages.append(self.image!)
                        }

                    }
                }

            }
        }
        
    }
    
    func retrievePhotos() {
        //get the data from the database
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments {
            snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                
                //loop thru all returned docs
                for doc in snapshot!.documents {
                    //extract the file path
                    paths.append(doc["url"] as! String)
                }
                //loop thru file path and fetch the data
                for path in paths {
                    //get ref to storage
                    let storageRef = Storage.storage().reference()
                    
                    //specify path
                    let fileRef = storageRef.child(path)
                    
                    //retireve data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) {
                        data, error in
                        
                        if error == nil && data != nil {
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }

                        }
                    }
                } // end loop through paths
            }
        }
        
        //display the images
    }
}

#Preview {
    Camera()
}
