//
//  ResetPasswordVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/19/24.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
        
        @IBOutlet weak var messageTV: UITextView!
        
        @IBOutlet weak var messageLBL: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
        }
        func sendLink(email: String) async {
            do {
                try await AuthenticationManager.shared.resetPassword(email: email)
                self.performSegue(withIdentifier: "resetPasswordToLogin", sender: self)
                
            } catch {
                
                self.messageLBL.text = ""
            }
        }
        
        @IBAction func onClickSendLink(_ sender: Any) {
            
            if emailTF.text == "" {
                messageLBL.text = "Please enter email!."
            }else {
                Task {
                    
                    await sendLink(email: emailTF.text!)
                }
            }
        }
        
        

        @IBAction func cancelPasswordReset(_ sender: Any) {
            
            self.performSegue(withIdentifier: "resetPasswordToLogin", sender: self)
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
