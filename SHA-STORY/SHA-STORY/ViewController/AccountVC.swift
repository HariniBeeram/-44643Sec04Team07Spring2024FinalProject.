//
//  AccountVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/19/24.
//

import UIKit
import Firebase
class AccountVC: UIViewController {

    
    let user = AppDelegate.username
    @IBOutlet weak var username: UILabel!
    {
        didSet{
            username.text = user
        }
    }
    
    @IBOutlet weak var reservations: UILabel!
    
    
    @IBOutlet weak var orders: UILabel!
    
    
    @IBAction func logout(_ sender: Any) {
        let userViewController = self.storyboard?.instantiateViewController(withIdentifier: "login") as? UIViewController
                self.view.window?.rootViewController = userViewController
                self.view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = AppDelegate.username
        // Do any additional setup after loading the view.
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
