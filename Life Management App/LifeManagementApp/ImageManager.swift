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
    
    func uploadImage(username: String, _ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void){
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // storage/userProfileImgs/username.jpg
        let imageName = "\(username).jpg"
        let imagesReference = storageReference.child("userProfileImgs").child(imageName)
        
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
}
