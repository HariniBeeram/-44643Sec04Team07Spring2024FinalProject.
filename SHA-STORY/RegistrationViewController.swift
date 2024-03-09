//
//  RegistrationViewController.swift
//  SHA-STORY
//
//  Created by ios 1 on 07/03/24.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var UsernameTF: UITextField!
    
    
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    @IBOutlet weak var ConfirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PasswordTF.isEnabled=false
        ConfirmPasswordTF.isEnabled=false
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func userName(_ sender: UITextField) {
        
        guard let text=UsernameTF.text, !text.isEmpty else{return}
        PasswordTF.isEnabled=true
    }
    
    
    @IBAction func password(_ sender: UITextField) {
        
        guard let passText=PasswordTF.text, !passText.isEmpty else{return}
        ConfirmPasswordTF.isEnabled=true
    }
    
    @IBAction func SignupBTN(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
