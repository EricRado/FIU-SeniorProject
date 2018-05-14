//
//  ImageManager.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 5/4/18.
//  Copyright © 2018 SeniorProject. All rights reserved.
//

import Foundation
import Firebase


class ImageManager: NSObject {
    var userRef = Database.database().reference(fromURL:
        "https://life-management-v2.firbase.com/").child("users")
    let storageRef = Storage.storage()
    var downloadedImage = UIImage()
    var uploadImgName = ""
    
    func uploadImage(user: User, _ image: UIImage, progressBlock:
        @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        // let storage reference pointing to images stored in Firebase
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // storage/userProfileImgs/username.jpg
        self.uploadImgName = "\(user.username).jpg"
        let imagesReference = storageReference.child("userProfileImgs").child(self.uploadImgName)
        
        // turn the selected image to data bits before uploading to firebase storage
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imagesReference.putData(imageData, metadata: metadata)
            { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                }else {
                    completionBlock(nil, error?.localizedDescription)
                }
            }
            // keeps track of the upload to firebase storage completion percentage
            uploadTask.observe(.progress) { (snapshot) in
                guard let progress = snapshot.progress else {return}
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            }
        }else {
            completionBlock(nil, "Image could not be converted to data.")
        }
    }
    
    // retrieving the image from firebase storage
    func downloadImage(user: User) {
        if let profileImageURL = user.imgURL {
            if let url = URL(string: profileImageURL) {
                let request = URLRequest(url: url)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        if let data = data {
                            self.downloadedImage = UIImage(data: data)!
                        }else {
                            print("Error retrieving image data.")
                        }
                    })
                }.resume()
            }
        }
    }
}









