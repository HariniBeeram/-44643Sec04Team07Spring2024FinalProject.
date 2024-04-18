//
//  FoodItemDetailVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/18/24.
//

import UIKit

class FoodItemDetailVC: UIViewController {
    
    @IBOutlet weak var imgUrl: UIImageView!
    
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var addToCart: UIButton!
    
    @IBAction func homeNavigate(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var header = ""
    var itemDesc = ""
    var itemPrice:Int = 0
    var itemImgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = header
        desc.text = itemDesc
        price.text = "$ " + String(itemPrice)
        if let url = URL(string: itemImgUrl){
            imgUrl.sd_setImage(with: url,placeholderImage: UIImage(named:"placeholder"))
        }
        
        
    }
}
