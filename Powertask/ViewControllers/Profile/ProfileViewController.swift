//
//  ProfileViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 14/1/22.
//

import UIKit
import SPIndicator

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet var uploadProgress: UIProgressView!
    @IBOutlet weak var editAndSaveButton: UIButton!
    @IBOutlet weak var widgetsCollectionView: UICollectionView!
    
    
    var userIsEditing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIsEditing = false
        changeViewWhileEditing(isEditing: userIsEditing!)
        widgetsCollectionView.delegate = self
        widgetsCollectionView.dataSource = self
        PTUser.shared.apiToken = "$2y$10$CJQbc6xLiSzD0IlD2epuVOJXoqXuBSjiAvI343FU2CH8ujLUf1ATq"
        PTUser.shared.imageUrl = "http://powertask.kurokiji.com/public/storage/images/qdoDkmOIKftL7iavSzrTqghNwrX1u8YLhPMGdWWw.jpg"
        PTUser.shared.name = "Daniel Torres"
        if let name = PTUser.shared.name {
            profileNameTextField.text = name
        }
        
        if let imageUrl = PTUser.shared.imageUrl, let url = URL(string: imageUrl) {
            profileImage.load(url: url)
        }
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
            if profileNameTextField.text == "" {
                let image = UIImage.init(systemName: "multiply.circle")!.withTintColor(.red, renderingMode: .alwaysOriginal)
                let indicatorView = SPIndicatorView(title: "Falta tu nombre", message: "El nombre es obligatorio", preset: .custom(image))
                indicatorView.present(duration: 5, haptic: .error, completion: nil)
            } else {
                PTUser.shared.name = profileNameTextField.text
                // guardar en preferencias
                // petición a editar perfil
                NetworkingProvider.shared.editNameInfo(name: profileNameTextField.text!) { msg in
                    let image = UIImage.init(systemName: "checkmark.circle")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysOriginal)
                    let indicatorView = SPIndicatorView(title: "Datos guardados", preset: .custom(image))
                    indicatorView.present(duration: 3, haptic: .success, completion: nil)
                } failure: { msg in
                    print(msg)
                }

                userIsEditing = false
                changeViewWhileEditing(isEditing: userIsEditing!)
            }
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
            NetworkingProvider.shared.uploadImage(image: file) { progressQuantity in
                self.uploadProgress.isHidden = false
                self.uploadProgress.progress = Float(progressQuantity)
            } success: { fileUrl in
                self.profileImage.image = file
                PTUser.shared.imageUrl = fileUrl
                self.uploadProgress.isHidden = true
                let image = UIImage.init(systemName: "checkmark.icloud")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysOriginal)
                let indicatorView = SPIndicatorView(title: "Foto subida correctamente", preset: .custom(image))
                indicatorView.present(duration: 3, haptic: .success, completion: nil)
            } failure: { error in
                self.uploadProgress.isHidden = true
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: collectionView.frame.width/2.1, height: collectionView.frame.width/2.1)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let animation = CATransition()
        animation.duration = 0.2
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionTimeCollectionViewCell", for: indexPath) as! SessionTimeCollectionViewCell
            cell.hoursLabel.text = "\(12)h"
            cell.minutesLabel.text = "\(23)m"
            cell.minutesLabel.layer.add(animation, forKey: nil)
            cell.hoursLabel.layer.add(animation, forKey: nil)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaysUntilPeriodEndsCollectionViewCell", for: indexPath) as! DaysUntilPeriodEndsCollectionViewCell
            cell.dayUntilEndLabel.text = "\(34) días"
            cell.dayUntilEndLabel.layer.add(animation, forKey: nil)
            cell.daysUntilEndProgress.setProgressWithAnimation(duration: 1.0, fromValue: 0, tovalue: 34/100)
                return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedTasksCollectionViewCell", for: indexPath) as! CompletedTasksCollectionViewCell
            cell.numberOfTaskCompletedLabel.text = String(13)
            cell.numberOfTask.text = "de \(323)"
            cell.numberOfTaskCompletedLabel.layer.add(animation, forKey: nil)
            cell.numberOfTask.layer.add(animation, forKey: nil)
                return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AverageGradeCollectionViewCell", for: indexPath) as! AverageGradeCollectionViewCell
            cell.averageGradeLabel.text = String(8.5)
            cell.averageGradeLabel.layer.add(animation, forKey: nil)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
