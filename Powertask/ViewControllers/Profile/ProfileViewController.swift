//
//  ProfileViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 14/1/22.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet var uploadProgress: UIProgressView!
    @IBOutlet weak var editAndSaveButton: UIButton!
    
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var redView: UIView!
    
    var userIsEditing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIsEditing = false
        changeViewWhileEditing(isEditing: userIsEditing!)
        blueView.layer.cornerRadius = 12
        yellowView.layer.cornerRadius = 12
        greenView.layer.cornerRadius = 12
        redView.layer.cornerRadius = 12
    }
    
    func changeViewWhileEditing (isEditing: Bool) {
        if isEditing {
            profileNameTextField.borderStyle = .roundedRect
            profileNameTextField.isEnabled = true
            editImageButton.isHidden = false
            editAndSaveButton.setTitle("Guardar", for: .normal)
        } else {
            profileNameTextField.borderStyle = .none
            profileNameTextField.isEnabled = false
            editImageButton.isHidden = true
            editAndSaveButton.setTitle("Editar", for: .normal)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func uploadNewImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @IBAction func editAndSaveProfileInfo(_ sender: Any) {
        if userIsEditing! {
            PTUser.shared.name = profileNameTextField.text
            // guardar en preferencias
            // petición a editar perfil
            userIsEditing = false
            changeViewWhileEditing(isEditing: userIsEditing!)
        } else {
            userIsEditing = true
            changeViewWhileEditing(isEditing: userIsEditing!)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let file = info[.editedImage] as? UIImage
        let url = info[.imageURL] as? URL
            
        if let file = file{
//            NetworkingProvider.shared.uploadImage(image: file, apiToken: apiToken) { progressQuantity in
//                self.uploadProgressBar.progress = Float(progressQuantity)
//            } success: { fileUrl in
//                self.profileImage.image = file
//                PTUser.shared.imageUrl = fileUrl
//            } failure: { error in
//
//            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
