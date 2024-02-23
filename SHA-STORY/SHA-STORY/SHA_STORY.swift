//
//  ViewController.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 2/19/24.
//

import UIKit
import Lottie

class SHA_STORY: UIViewController {
    
    
    @IBOutlet weak var LaunchLAV: LottieAnimationView!{
        didSet{
            LaunchLAV.animation = .named("Animation")
            LaunchLAV.alpha=1
            LaunchLAV.play(){[weak self] _ in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration:1, delay: 0.1, options: [.curveEaseIn]){
                    self!.LaunchLAV.alpha = 0
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Testing branch
        // Do any additional setup after loading the view.
    }
    
}
