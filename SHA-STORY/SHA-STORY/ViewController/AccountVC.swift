//
//  AccountVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/19/24.
//

import UIKit
import Firebase
class AccountVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var pickUpOrder:[(orderedDate: String,cartItems:[CartItem])] = []
    var dineInOrder:[(date: String,cartItems:[CartItem],reservedTables: [String],time: String)] = []
    var reservationsData:[(date:String, reservedTables: [String],time: String)] = []
    var user = AppDelegate.username
    let db = Firestore.firestore()
    var selectedSegmentIndex = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegmentIndex {
               case 0:
                   if section == 0 {
                       return pickUpOrder.count
                   } else {
                       return dineInOrder.count
                   }
               case 1:
                   return reservationsData.count
               default:
                   return 0
               }
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedSegmentIndex {
        case 0:
            if section == 0 {
                return "PickUpOrders"
            } else if section == 1 {
                return "Dine-In-Orders"
            }
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Check which segment is selected
        switch selectedSegmentIndex {
        case 0:
            // Determine which type of order is selected (pickUp or dineIn)
            if indexPath.section == 0 {
                // If it's a pickUp order, pass the associated cartItems to orderDetailTVC
                let cartItems = pickUpOrder[indexPath.row].cartItems
                navigateToOrderDetail(with: cartItems)
            } else {
                // If it's a dineIn order, pass the associated cartItems to orderDetailTVC
                let cartItems = dineInOrder[indexPath.row].cartItems
                navigateToOrderDetail(with: cartItems)
            }
        default:
            break
        }
    }
    
    func navigateToOrderDetail(with cartItems: [CartItem]) {
        // Instantiate orderDetailTVC from storyboard
        let orderDetailVC = storyboard?.instantiateViewController(withIdentifier: "orderDetailTVC") as! orderDetailTVC
        
        // Pass the cartItems to orderDetailTVC
        orderDetailVC.cartItems = cartItems
        
        // Push orderDetailTVC onto navigation stack
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! accountCell
        switch selectedSegmentIndex {
              case 0:
               if indexPath.section == 0 {
                      let order = pickUpOrder[indexPath.row]
                      cell.first.text = order.cartItems.first?.name ?? ""
                      let totalPrice = order.cartItems.reduce(0) { $0 + ($1.price * $1.count) }
                      cell.second.text = "\(totalPrice) $"
                      cell.third.text = order.orderedDate
                      cell.accessoryType = .disclosureIndicator
                      if order.cartItems.count > 1 {
                       cell.first.text! += " + \(order.cartItems.count - 1) items"
                          cell.fourth.text = ""
                   }
                  }
               else {
                      let order = dineInOrder[indexPath.row]
                      let totalPrice = order.cartItems.reduce(0) { $0 + ($1.price * $1.count) }
                      cell.first.text = order.cartItems.first?.name ?? ""
                      
                      if order.cartItems.count > 1 {
                          cell.first.text! += " + \(order.cartItems.count - 1) items"
                      }
                      cell.accessoryType = .disclosureIndicator
                      cell.second.text = "\(totalPrice) $"
                      cell.third.text = order.date
                      cell.fourth.text = order.reservedTables.joined(separator: ", ")
                  }
              case 1:
               let reservation = reservationsData[indexPath.row]
                   cell.first.text = reservation.reservedTables.first ?? ""
                   cell.second.text = reservation.date
                   cell.third.text = reservation.time
                   cell.fourth.text = ""
                  cell.accessoryType = .none
              default:
                  break
              }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
         switch selectedSegmentIndex {
         case 0:
             return 2
         case 1:
             return 1
         default:
             return 0
         }
     }
    
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
        
    }

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
        tableView.delegate = self
        tableView.dataSource = self
        

        
        guard let atIndex = user.firstIndex(of: "@") else {
            navigationItem.title = "Hello" + user
            return
        }
        
        navigationItem.title =  "Hello "+String(user[..<atIndex])
    }
    override func viewWillAppear(_ animated: Bool) {
        pickUpOrder.removeAll()
        dineInOrder.removeAll()
        reservationsData.removeAll()
        fetchPickUpOrders()
        fetchDineInOrders()
        fetchReservations()
    }
    func fetchPickUpOrders() {
        db.collection("pickupOrders").whereField("username", isEqualTo: user ).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching pick-up orders: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No pick-up orders found")
                return
            }
            
            for document in documents {
                if let orderedDate = document.data()["orderedDate"] as? String,
                   let cartItemsData = document.data()["cartItems"] as? [[String: Any]] {
                    var cartItems: [CartItem] = []
                    for itemData in cartItemsData {
                        if let itemName = itemData["name"] as? String,
                           let itemPrice = itemData["price"] as? Int,
                           let itemImgUrl = itemData["imgUrl"] as? String,
                           let itemId = itemData["id"] as? String,
                           let itemCount = itemData["count"] as? Int {
                            let cartItem = CartItem(name: itemName, price: itemPrice, imgUrl: itemImgUrl, id: itemId, count: itemCount)
                            cartItems.append(cartItem)
                        }
                    }
                    self.pickUpOrder.append((orderedDate: orderedDate, cartItems: cartItems))
                }
            }
            self.tableView.reloadData()
        }
     
    }

    func fetchDineInOrders() {
        db.collection("dineInOrders").whereField("username", isEqualTo: user ).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching dine-in orders: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No dine-in orders found")
                return
            }
            
            for document in documents {
                if let date = document.data()["date"] as? String,
                   let time = document.data()["time"] as? String,
                   let reservedTables = document.data()["reservedTables"] as? [String],
                   let cartItemsData = document.data()["cartItems"] as? [[String: Any]] {
                    var cartItems: [CartItem] = []
                    for itemData in cartItemsData {
                        
                        if let itemName = itemData["name"] as? String,
                           let itemPrice = itemData["price"] as? Int,
                           let itemImgUrl = itemData["imgUrl"] as? String,
                           let itemId = itemData["id"] as? String,
                           let itemCount = itemData["count"] as? Int {
                            let cartItem = CartItem(name: itemName, price: itemPrice, imgUrl: itemImgUrl, id: itemId, count: itemCount)
                            cartItems.append(cartItem)
                        }
                    }
                    self.dineInOrder.append((date: date, cartItems: cartItems, reservedTables: reservedTables, time: time))
                }
            }
            self.tableView.reloadData()
        }
        
    }

        func fetchReservations(){
            
            db.collection("Table_Reservation").whereField("username", isEqualTo: user ).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching document IDs: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                for document in documents{
                    if let date = document.data()["date"] as? String,
                       let time = document.data()["time"] as? String,
                       let reservedTables = document.data()["reservedTables"] as? [String] {
                        self.reservationsData.append((date: date, reservedTables: reservedTables, time: time))
                    }
                }
                self.tableView.reloadData()
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
