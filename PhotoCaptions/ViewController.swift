//
//  ViewController.swift
//  PhotoCaptions
//
//  Created by Matteo Orru on 28/03/24.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photos = [PhotosTaken]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Captions"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhotoButton))
        

        
    }//viewDidLoad
    
    
    //setting tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 100
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pictures", for: indexPath)
        let picture = photos[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.textLabel?.text = picture.caption
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.imageView?.layer.borderWidth = 1.5
        cell.imageView?.layer.borderColor = UIColor.white.cgColor
        
        //adding long press gesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.imageView?.addGestureRecognizer(longPressGesture)
        cell.imageView?.isUserInteractionEnabled = true


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = photos[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = picture
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let pngData = image.pngData() {
            try? pngData.write(to: imagePath)
        }
        
        let picture = PhotosTaken(caption: "Unknown", image: imageName)
        photos.append(picture)
        tableView.reloadData()
        
        let ac = UIAlertController(title: "Give it a name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            picture.caption = newName
            
            self?.tableView.reloadData()
            picker.dismiss(animated: true)
        })
        
        picker.present(ac, animated: true)
    }
    
    
    
    
    @objc func takePhotoButton() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
        } else {
            print("Camera not available.")
        }
    }
    
    
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        let longPressLocation = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: longPressLocation),
              !photos.isEmpty,
              indexPath.row < photos.count else { return }
        
        let photo = photos[indexPath.row]
        
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        // Rename Action
        let renameAction = UIAlertAction(title: "Rename", style: .default) { _ in
            let renameAlertController = UIAlertController(title: "Rename photo", message: "", preferredStyle: .alert)
            renameAlertController.addTextField { textField in
                textField.placeholder = photo.caption
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let newName = renameAlertController.textFields?[0].text else { return }
                photo.caption = newName
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            renameAlertController.addAction(saveAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            renameAlertController.addAction(cancelAction)
            
            self.present(renameAlertController, animated: true, completion: nil)
        }
        
        alertController.addAction(renameAction)
        
        // Delete Action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.photos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        alertController.addAction(deleteAction)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present UIAlertController
        present(alertController, animated: true, completion: nil)
    }
    

}//viewController

