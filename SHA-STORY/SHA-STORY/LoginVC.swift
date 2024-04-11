//
//  LoginVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/11/24.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var messageLBL: UILabel!
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBTN: UIButton!
    
    @IBAction func onLogin(_ sender: UIButton) {
        guard let email = usernameTF.text, !email.isEmpty else {
            messageLBL.text = "Please enter Username!"
            return
        }
        
        guard let pass = passwordTF.text, !pass.isEmpty else {
            messageLBL.text = "Please enter Password!"
            return
        }
        messageLBL.text = ""
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
            if error != nil {
                self?.messageLBL.text = "Invalid Login Credentials! Please try again"
            } else {
               self?.performSegue(withIdentifier: "ShowMenu", sender: self)
               self?.messageLBL.text = "login successful"
                
            }
        }
        
        
    }
    
}
