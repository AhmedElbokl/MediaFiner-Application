//
//  UserModel.swift
//  Media Finder
//
//  Created by ReMoSTos on 05/05/2023.
//

import Foundation
import UIKit

public enum Gender: String, Codable {
    case male = "Male"
    case female = "Female"
}
struct User: Codable {
    var name: String
    var phone: String
    var email: String
    var password: String
    var address: String
    var gender: Gender
    var image: CodableImage
}

struct CodableImage: Codable {

    let imageData: Data?
    
    init(image: UIImage) {
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
    
    func getImage() -> UIImage? {
        guard let image = self.imageData else {return nil}
        return UIImage(data: image)
    }
    
}


