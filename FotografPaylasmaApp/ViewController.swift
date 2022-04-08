//
//  ViewController.swift
//  FotografPaylasmaApp
//
//  Created by Bora Gündoğu on 1.04.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func girisYapTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != ""{
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata Aldınız, Lütfen tekrar deneyin.")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
        else{
            self.hataMesaji(titleInput: "Hata!", messageInput: "Email ve parola giriniz")
        }
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            // kayıt olma işlemi
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        
        else{
            hataMesaji(titleInput: "Hata", messageInput: "Email ve parola giriniz.")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

