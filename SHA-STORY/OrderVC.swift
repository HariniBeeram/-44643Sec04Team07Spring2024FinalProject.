//
//  OrderVC.swift
//  SHA-STORY
//
//  Created by Harini Beeram on 4/12/24.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var pickupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func deliveryAction(_ sender: UIButton) {
        // Example functionality for delivery button
        placeOrder(isDelivery: true)
    }
    
    @IBAction func pickupAction(_ sender: UIButton) {
        // Example functionality for pickup button
        placeOrder(isDelivery: false)
    }
    
    func placeOrder(isDelivery: Bool) {
        // Code to place the order based on delivery or pickup
        if isDelivery {
            print("Ordering food for delivery...")
            // Code to initiate food delivery order
        } else {
            print("Ordering food for pickup...")
            // Code to initiate food pickup order
        }
        
        // After initiating the order, you can perform additional actions like navigating to a confirmation screen or updating UI elements.
    }
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
