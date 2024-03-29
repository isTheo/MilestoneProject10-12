//
//  DetailViewController.swift
//  PhotoCaptions
//
//  Created by Matteo Orru on 29/03/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var detailedImage: UIImageView!
    
    var selectedImage: PhotosTaken?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = selectedImage?.image {
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            detailedImage.image = UIImage(contentsOfFile: imagePath.path)
        }
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    
}
