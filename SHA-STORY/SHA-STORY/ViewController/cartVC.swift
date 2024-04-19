//
//  cartVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/18/24.
//

import UIKit
import Firebase
class cartVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ItemCellDelegate{
    
    let timeOptions = ["7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM", "9:00 PM", "9:30 PM", "10:00 PM"]

    
    @IBOutlet weak var messageLBL: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var pickUpBtn: UIButton!
    
    
    
    @IBOutlet weak var dineInBtn: UIButton!
    
    @IBAction func pickUp(_ sender: UIButton) {
        showAlert(message: "Your order will be ready in 30 minutes.")
        
    }
    
    func showAlert(message: String) {
            let alertController = UIAlertController(title: "Order Confirmation", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
            
            self.addOrderToPickupOrders()
                  }
                  alertController.addAction(okAction)
                  present(alertController, animated: true, completion: nil)
        }
    func addOrderToPickupOrders() {
            let db = Firestore.firestore()
            let documentId = "sairam"
            db.collection("orders").document(documentId).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data(), let cartItemsData = data["cartItems"] as? [[String: Any]] {
                        self.addToPickupOrders(cartItems: cartItemsData)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        func addToPickupOrders(cartItems: [[String: Any]]) {
            let db = Firestore.firestore()
            let username = "sairam"
            let orderedDate = Timestamp(date: Date())
            let pickupOrderData: [String: Any] = [
                "username": username,
                "orderedDate": orderedDate,
                "cartItems": cartItems
            ]
            db.collection("pickupOrders").addDocument(data: pickupOrderData) { error in
                if let error = error {
                    print("Error adding pickup order: \(error)")
                } else {
                    print("Pickup order added successfully!")
                    
                    // Clear the cart items after adding the pickup order
                    self.clearCartItems()
                    DispatchQueue.main.async {
                                    self.fetchCartItems()
                                    self.tableView.reloadData()
                                    self.totalPrice.text = "$0"
                                    self.pickUpBtn.isEnabled = false
                                    self.dineInBtn.isEnabled = false
                                    self.messageLBL.text = "Cart is empty"
                                }
                }
            }
        }
    func clearCartItems() {
            let db = Firestore.firestore()
            let documentId = "sairam" // Use the appropriate document ID
            
            // Clear the cart items in the "orders" collection
            db.collection("orders").document(documentId).updateData(["cartItems": []]) { error in
                if let error = error {
                    print("Error clearing cart items: \(error)")
                } else {
                    
                    print("Cart items cleared successfully!")
                }
            }
        }
    
    @IBAction func DineIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showTableReservation", sender: Any?.self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableReservation",
            let destinationVC = segue.destination as? ReserveVC
            {
            destinationVC.dineInSelected = true
                }
        }
    var cartItems: [CartItem] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           pickUpBtn.isEnabled = true
           pickUpBtn.isEnabled = true
           messageLBL.text = ""
           tableView.delegate = self
           tableView.dataSource = self

           
           fetchCartItems()
       }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        pickUpBtn.isEnabled = true
        dineInBtn.isEnabled = true
        messageLBL.text = ""
         fetchCartItems()
     }
       func fetchCartItems() {
           let db = Firestore.firestore()
           let documentId = "sairam"
           
           db.collection("orders").document(documentId).getDocument { (document, error) in
               if let document = document, document.exists {
                   if let data = document.data(), let cartItemsData = data["cartItems"] as? [[String: Any]] {
                       self.cartItems = cartItemsData.compactMap { itemData in
                           return CartItem(
                               name: itemData["name"] as? String ?? "",
                               price: itemData["price"] as? Int ?? 0,
                               imgUrl: itemData["imgUrl"] as? String ?? "",
                               id: itemData["id"] as? String ?? "",
                               count: itemData["count"] as? Int ?? 0
                           )
                       }
                       self.tableView.reloadData()
                       self.updateTotalPrice()
                   }
               } else {
                
                   print("Document does not exist")
               }
           }
       }
       
       func updateTotalPrice() {
           let totalPriceCart = cartItems.reduce(0) { $0 + ($1.price * $1.count) }
           totalPrice.text = "$\(totalPriceCart)"
           if(totalPrice.text == "$0")
           {
               self.pickUpBtn.isEnabled = false
               self.dineInBtn.isEnabled = false
               self.messageLBL.text = "Cart is empty"
           }
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return cartItems.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! itemCellTableViewCell
           cell.configure(with: cartItems[indexPath.row])
           cell.delegate = self
           return cell
       }
       
       func stepperValueChanged(for cell: itemCellTableViewCell, newValue: Int) {
           guard let indexPath = tableView.indexPath(for: cell) else { return }
           cartItems[indexPath.row].count = newValue
           updateCartItemInDatabase(at: indexPath, with: newValue)
           updateTotalPrice()
       }
       
       func updateCartItemInDatabase(at indexPath: IndexPath, with newValue: Int) {
           let db = Firestore.firestore()
           let documentId = "sairam"
           
           db.collection("orders").document(documentId).getDocument { (document, error) in
               if let document = document, document.exists {
                   var cartItemsData = document.data()?["cartItems"] as? [[String: Any]] ?? []
                   cartItemsData[indexPath.row]["count"] = newValue
                   
                   db.collection("orders").document(documentId).setData(["cartItems": cartItemsData], merge: true) { error in
                       if let error = error {
                           print("Error updating document: \(error)")
                       } else {
                           print("Document successfully updated")
                       }
                   }
               }
               else {
                   print("Document does not exist")
               }
           }
       }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let removedItem = cartItems.remove(at: indexPath.row)
                updateDatabaseAfterItemDeletion(removedItem)
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateTotalPrice()
            }
        }
    func updateDatabaseAfterItemDeletion(_ removedItem: CartItem) {
            let db = Firestore.firestore()
            let documentId = "sairam"
            db.collection("orders").document(documentId).getDocument { (document, error) in
                if let document = document, document.exists {
                    var cartItemsData = document.data()?["cartItems"] as? [[String: Any]] ?? []
                    cartItemsData.removeAll { $0["id"] as? String == removedItem.id }
                    db.collection("orders").document(documentId).setData(["cartItems": cartItemsData], merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document successfully updated after item deletion")
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
      
   }
    
    

