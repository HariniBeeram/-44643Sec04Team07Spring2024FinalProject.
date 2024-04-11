//
//  RegistrationViewController.swift
//  SHA-STORY
//
//  Created by ios 1 on 07/03/24.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var UsernameTF: UITextField!
    
    
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    @IBOutlet weak var ConfirmPasswordTF: UITextField!
    
    
    @IBAction func rePasswordCheck(_ sender: UITextField) {
        guard let password = sender.text else { return }
        if password.count < 8 {
            meessageLBL.text =  "Password must be at least 6 characters long!"
        } else {
            meessageLBL.text = ""
        }
    }
    
    @IBAction func passwordCheck(_ sender: UITextField) {
        guard let password = sender.text else { return }
        if password.count < 8 {
            meessageLBL.text =  "Password must be at least 6 characters long!"
        } else {
            meessageLBL.text = ""
        }
    }
    
    
    @IBOutlet weak var registerBTN: UIButton!
    
    @IBAction func createUser(_ sender: UIButton) {
        guard let email = UsernameTF.text, !email.isEmpty else {
            meessageLBL.text = "Please enter email!"
            return
        }
        
        guard let password = PasswordTF.text, !password.isEmpty else {
            meessageLBL.text =  "Please enter password in both fields!"
            return
        }
        
        guard let checkPassword = ConfirmPasswordTF.text, !checkPassword.isEmpty else {
            meessageLBL.text =  "Please enter password in both fields!"
            return
        }
        
        guard password == checkPassword else {
            meessageLBL.text = "Password should match!"
            return
        }
        
        guard password.count >= 8 else {
            meessageLBL.text = "Password must be at least 6 characters long!"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.meessageLBL.text = "Invalid details"
            } else {
                
                self?.performSegue(withIdentifier: "CreateAccount", sender: self)
            }
        }
    }
    
    @IBAction func cancelAccountCreation(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccount", sender: self)
    }
    @IBOutlet weak var meessageLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
}

