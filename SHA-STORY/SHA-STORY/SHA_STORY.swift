//
//  ViewController.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 2/19/24.
//

import UIKit
import Lottie

class SHA_STORY: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Testing branch
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var LaunchLAV : LottieAnimationView!{
        didSet {
            LaunchLAV.animation = LottieAnimation.named("cheflogo")
            LaunchLAV.alpha = 1
            LaunchLAV.play { [weak self] _ in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut]) {
                    self?.LaunchLAV.alpha = 0.0
                }
            }
        }
        
    }
}
