//
//  UploadViewController.swift
//  FotografPaylasmaApp
//
//  Created by Bora Gündoğu on 1.04.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    

    @IBAction func uploadButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { storagemetadata, error in
                if error != nil {
                    self.hataMesaji(title: "Hata!", message: error?.localizedDescription ?? "Hata aldınız tekrar deneyin.")
                }
                else{
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            if let imageUrl = imageUrl{
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                let authmail = Auth.auth().currentUser!.email
                                
                                let firestorePost = ["gorselurl" : imageUrl, "yorum" : self.yorumTextField.text!, "email" : authmail!, "tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil{
                                        self.hataMesaji(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız tekrar deneyiniz.")
                                    }
                                    else{
                                        
                                        self.imageView.image = UIImage(named: "gorselsecme")
                                        self.yorumTextField.text = ""
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
    
    func hataMesaji(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
