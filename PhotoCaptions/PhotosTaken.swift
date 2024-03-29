//
//  PhotosTaken.swift
//  PhotoCaptions
//
//  Created by Matteo Orru on 28/03/24.
//

import UIKit

class PhotosTaken: NSObject, Codable {
    
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }

}
