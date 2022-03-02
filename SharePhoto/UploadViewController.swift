//
//  UploadViewController.swift
//  SharePhoto
//
//  Created by yunus oktay on 1.03.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func selectedImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadTappedButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { storagemetadata, error in
                if error != nil {
                    self.alertMessage(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin!")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            if let imageUrl = imageUrl {
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                let firestorePost = ["gorselUrl" : imageUrl, "yorum" : self.commentTextField.text!, "email" : Auth.auth().currentUser!.email, "tarih" : FieldValue.serverTimestamp()]  as [String : Any]
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil {
                                        self.alertMessage(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin!")
                                    } else {
                                        
                                        self.commentTextField.text = ""
                                        self.imageView.image = UIImage(named: "gorselSec")
                                        self.tabBarController?.selectedIndex = 0
                                        
                                    }
                                }
                                
                                
                            }
                            
                           
                        }
                    }
                }
            }
            
        }
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
   
}
