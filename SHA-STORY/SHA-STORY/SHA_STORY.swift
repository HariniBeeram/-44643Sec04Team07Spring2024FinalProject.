//
//  ViewController.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 2/19/24.
//

import UIKit
import Lottie

class SHA_STORY: UIViewController {
    
    
    @IBOutlet weak var Username: UILabel!
    
    
    @IBOutlet weak var UsernameTF: UITextField!
    
    
    @IBOutlet weak var Password: UILabel!
    
    
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    @IBOutlet weak var Login: UIButton!
    
    @IBOutlet weak var titleAnimationLBL: UILabel!{
        didSet{
            titleAnimationLBL.text = "SHA Story"
        }
    }
    @IBOutlet weak var lottileView: UIView!{
            didSet{
                LaunchLAV.animation = .named("cheflogo")
                LaunchLAV.alpha=1
                LaunchLAV.play(){[weak self] _ in
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration:2, delay: 0.5, options: [.curveEaseIn]){
                        self!.lottileView.alpha = 0
                        
                        
                    }
                }
            }
        }
   

    
    @IBOutlet weak var taglineLBL: UILabel!{
        didSet{
            taglineLBL.text = "- where every bite tells a story"
        }
    }
    
    
    
    
    @IBOutlet weak var LaunchLAV: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Testing branch
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func LoginAction(_ sender: UIButton) {
        guard let username = UsernameTF.text, !username.isEmpty else {
                    showAlert(message: "Please enter your username")
                    return
                }
                
                guard let password = PasswordTF.text, !password.isEmpty else {
                    showAlert(message: "Please enter your password")
                    return
                }
    }
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    

