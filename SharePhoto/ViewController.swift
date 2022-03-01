//
//  ViewController.swift
//  SharePhoto
//
//  Created by yunus oktay on 28.02.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginTappedButton(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdataresult, error) in
                if error != nil {
                    self.alertMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin!")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.alertMessage(titleInput: "Hata!", messageInput: "Email ve Şifre Giriniz!")
        }
        
    }
    
    @IBAction func registerTappedButton(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil {
                    self.alertMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            alertMessage(titleInput: "Hata!", messageInput: "Email ve Şifre Giriniz!")
        }
        
    }
    
    func alertMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}

