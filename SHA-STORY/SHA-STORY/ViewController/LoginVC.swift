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
                AppDelegate.username = self!.usernameTF.text!
                self?.messageLBL.text = "login successful"
                let tapBarController = self?.storyboard?.instantiateViewController(identifier: "shaStoryTapBar") as? UITabBarController
                self!.view.window?.rootViewController = tapBarController
                self!.view.window?.makeKeyAndVisible()
          
                
            }
        }
        
        
    }
    
}
