//
//  ImageManager.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 11/24/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import Foundation
import Firebase

class ImageManager: NSObject{
    var userRef = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/").child("users")
    let storageRef = Storage.storage()
    var downloadedImage = UIImage()
    var uploadImgName = ""
    
    func uploadImage(user: User, _ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void){
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // storage/userProfileImgs/username.jpg
        self.uploadImgName = "\(user.username).jpg"
        let imagesReference = storageReference.child("userProfileImgs").child(self.uploadImgName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8){
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let uploadTask = imagesReference.putData(imageData, metadata: metaData, completion: {(metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                    
                }else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            uploadTask.observe(.progress, handler: {(snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to data.")
        }
    }
    
    func downloadImage(user: User){
        if let profileImageURL = user.imgURL{
            print("IMAGE MANAGER : \(profileImageURL)")
            if let url = URL(string: profileImageURL){
                let request = URLRequest(url: url)
                URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                
                    if let error = error{
                        print(error.localizedDescription)
                        return
                }
                
                DispatchQueue.main.async(execute: {
                    self.downloadedImage = UIImage(data: data!)!
                })
                
                }).resume()
            }
        }
    }
}







