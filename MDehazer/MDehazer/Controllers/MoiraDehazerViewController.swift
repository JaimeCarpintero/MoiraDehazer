//
//  ViewController.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021
//

import UIKit

class MoiraDehazerViewController: UIViewController {

    @IBOutlet weak var dehazeImageView: UIImageView!
    
    @IBOutlet weak var dehazeFactorSlider: UIStackView!
    
    @IBOutlet weak var saturationFactorSlider: NSLayoutConstraint!
    
    private let mImagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mImagePicker.delegate = self
        
        mImagePicker.sourceType = .photoLibrary
        mImagePicker.allowsEditing = true
    }
    
    @IBAction func onLoadImagePressed(_ sender: UIBarButtonItem) {
        //NOTE [Jaime]: Here maybe we can use the callback to start the dehazing process
        present(mImagePicker, animated: true, completion: nil)
    }
}

//MARK: -Extensions

extension MoiraDehazerViewController: UINavigationControllerDelegate{
}

extension MoiraDehazerViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePickedByUser = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            dehazeImageView.image = imagePickedByUser
            guard let ciimage = CIImage(image: imagePickedByUser) else{
                fatalError("Could not load image")
            }
        }
        mImagePicker.dismiss(animated: true, completion: nil)
    }
}

