//
//  FoodItemDetailVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/18/24.
//

import UIKit
import Firebase
class FoodItemDetailVC: UIViewController {
    
    @IBOutlet weak var imgUrl: UIImageView!
    
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var addToCart: UIButton!
    
    @IBAction func addToOrders(_ sender: UIButton) {
        let db = Firestore.firestore()
        let ordersCollection = db.collection("orders")
        
        let documentId = "sairam"
        ordersCollection.document(documentId).getDocument { (document, error) in
            if let document = document, document.exists {
                if var data = document.data(), var cartItems = data["cartItems"] as? [[String: Any]] {
                    if let existingItemIndex = cartItems.firstIndex(where: { $0["id"] as? String == self.itemId }) {
                        if var count = cartItems[existingItemIndex]["count"] as? Int {
                            count += 1
                            cartItems[existingItemIndex]["count"] = count
                        }
                    } else {
                        let newItem: [String: Any] = [
                            "name": self.header,
                            "price": self.itemPrice,
                            "imgUrl": self.itemImgUrl,
                            "id": self.itemId,
                            "count": 1
                            
                        ]
                        cartItems.append(newItem)
                    }
                    ordersCollection.document(documentId).updateData(["cartItems": cartItems]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document updated successfully!")
                        }
                    }
                }
            } else {
                let newItem: [String: Any] = [
                    "name": self.header,
                    "price": self.itemPrice,
                    "imgUrl": self.itemImgUrl,
                    "id": self.itemId,
                    "count": 1
                ]
                ordersCollection.document(documentId).setData(["cartItems": [newItem]]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully!")
                    }
                }
            }
        }
        self.showAlert()
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Item Added to Cart", message: "Would you like to Order more?", preferredStyle: .alert)
        let homeAction = UIAlertAction(title: "Order more", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(homeAction)
        let ordersAction = UIAlertAction(title: "Checkout", style: .default) { _ in
            self.performSegue(withIdentifier: "cart", sender: Any?.self)
        }
        
        alertController.addAction(ordersAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func homeNavigate(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
                
    }
    
    var header = ""
    var itemDesc = ""
    var itemPrice:Int = 0
    var itemImgUrl = ""
    var itemId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        navigationItem.title = header
        desc.text = itemDesc
        price.text = "$ " + String(itemPrice)
        if let url = URL(string: itemImgUrl){
            imgUrl.sd_setImage(with: url,placeholderImage: UIImage(named:"placeholder"))
        }
        
        
    }
}
