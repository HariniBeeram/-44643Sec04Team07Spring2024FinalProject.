//
//  TableBookingViewController.swift
//  SHA-STORY
//
//  Created by Muthyala,Sai Ram Reddy on 4/12/24.
//

import UIKit
import ARKit
import SceneKit
import Firebase
class TableBookingVC: UIViewController,UIGestureRecognizerDelegate {
    
    var selectedDate: Date = Date()
    var selectedTime: String = ""
    var numberOfPeople: Int = 1
    var tableUser: [String: String] = [:]
    var username: String = AppDelegate.username
    let db = Firestore.firestore()
    let dateFormatter = DateFormatter()
    let reservedColor = UIColor.red
    let reservingColor = UIColor.green
    let originalColor = UIColor.brown
    var tableNodes:[String] = ["Object_20","Object_124","Object_98","Object_194","Object_150","Object_72","Object_592","Object_615","Object_46"]
    
    
    @IBAction func navigateToReserve(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func makeReservation(_ sender: Any) {
        var reservedTables: [String] = []
        for nodeName in tableNodes{
            if let tableNode = imgView.scene?.rootNode.childNode(withName: nodeName, recursively: true)
            {
                if let currentColor = tableNode.geometry?.firstMaterial?.diffuse.contents as? UIColor {
                    if currentColor.isEqual(reservingColor) {
                        reservedTables.append(nodeName);
                        
                    }
                }
            }
        }
        
        if(reservedTables.count == 0){
            let alertController = UIAlertController(title: "Alert", message: "Please select atleast one table", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else{
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            handleTableSelection(date: dateFormatter.string(from: selectedDate), time: selectedTime, tables: reservedTables)
        }
    }
        
    @IBOutlet weak var reserve: UIButton!
    
    @IBOutlet weak var imgView: SCNView!
    var tableNode: SCNNode?
   
    var userTables:[String] = []
    var reserved:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "restaurant3", withExtension: "usdz"),
              let scene = try? SCNScene(url: url) else {
            fatalError("Failed to load the USDZ file.")
        }
        
        for nodeName in tableNodes{
            if let tableNode = scene.rootNode.childNode(withName: nodeName, recursively: true) {
                tableNode.geometry?.firstMaterial?.diffuse.contents = originalColor
            }
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        db.collection("Table_Reservation").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching document IDs: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            for document in documents {
                print(document.data())
                print("username \(self.username)")
                print("time: \(self.selectedTime)")
                print("date: \(self.selectedDate)")
                
                if let username = document.data()["username"] as? String, username == self.username , let time = document.data()["time"] as? String, time == self.selectedTime, let date = document.data()["date"] as? String, date == self.dateFormatter.string(from: self.selectedDate)  {
                    if let tables = document.data()["reservedTables"] as? [String]{
                        self.userTables = tables
                        for nodeName in self.userTables {
                            if let tableNode = scene.rootNode.childNode(withName: nodeName, recursively: true) {
                                tableNode.geometry?.firstMaterial?.diffuse.contents = self.reservingColor
                            }
                        }
                    }
                }
                else{
                    if let tables = document.data()["reservedTables"] as? [String],let time = document.data()["time"] as? String, time == self.selectedTime, let date = document.data()["date"] as? String, date == self.dateFormatter.string(from: self.selectedDate) {
                        self.reserved = tables
                        for nodeName in self.reserved {
                            if let tableNode = scene.rootNode.childNode(withName: nodeName, recursively: true) {
                                tableNode.geometry?.firstMaterial?.diffuse.contents = self.reservedColor
                            }
                        }
                        
                    }
                }
            }
            self.setReservation(scene: scene)
        }
    }
    
    func setReservation(scene: SCNScene){
       
        imgView.scene = scene
        imgView.backgroundColor = UIColor.white
        imgView.autoenablesDefaultLighting = true
        imgView.isUserInteractionEnabled = true
        imgView.allowsCameraControl = true
       // imgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height )
        
        //imgView.frame = UIScreen.main.bounds
        print("scene\(scene)")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imgView.addGestureRecognizer(tapGesture)
        
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: imgView)
        let hitTestResults = imgView.hitTest(location, options: nil)
        
        if let tappedNode = hitTestResults.first?.node  {
            let nodeName = tappedNode.name ?? "Unnamed Node"
            if tableNodes.contains(nodeName){
                print("node name: \(nodeName)")
                if let currentColor = tappedNode.geometry?.firstMaterial?.diffuse.contents as? UIColor {
                    if currentColor.isEqual(reservedColor) {
                        let alertController = UIAlertController(title: "Alert", message: "Table is already booked", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        present(alertController, animated: true, completion: nil)
                    }
                    else if currentColor.isEqual(reservingColor) {
                        tappedNode.geometry?.firstMaterial?.diffuse.contents = originalColor
                        print("Tapped node name: \(nodeName)")
                        
                    }
                    else{
                        tappedNode.geometry?.firstMaterial?.diffuse.contents = reservingColor
                        print("Tapped node name: \(nodeName)")
                    }
                }
            }
        }
    }
    
    func handleTableSelection(date: String, time: String, tables: [String]) {
        
        let reservationData: [String: Any] = [
            "date": date,
            "time": time,
            "reservedTables": tables,
            "username": self.username
            
        ]
        
        
        
        
        db.collection("Table_Reservation").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching document IDs: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            var userHasReservation = false
            var existingDocumentID: String?
            
            // Iterate through each document
            for document in documents {
                let docID = document.documentID
                
                // Check if the user has already reserved a table for this document ID
                if let username = document.data()["username"] as? String, username == self.username {
                    userHasReservation = true
                    existingDocumentID = docID
                    break
                }
            }
            if userHasReservation, let existingDocID = existingDocumentID {
                
                self.db.collection("Table_Reservation").document(existingDocID).setData(reservationData, merge: true) { error in
                    if let error = error {
                        print("Error updating table reservation: \(error.localizedDescription)")
                    } else {
                        self.showAlertAndNavigateToHome()
                    }
                }
            }
            else {
                let uuid = UUID().uuidString
                let documentID = date + "_" + time + "_" + uuid
                self.db.collection("Table_Reservation").document(documentID).setData(reservationData) { error in
                    if let error = error {
                        print("Error adding table reservation: \(error.localizedDescription)")
                    } else {
                        self.showAlertAndNavigateToHome()
                    }
                }
            }
        }
    }
    
    func showAlertAndNavigateToHome() {
        let alertController = UIAlertController(title: "Success", message: "Table booked successfully!", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default) { _ in
              self.dismiss(animated: true, completion: nil) // Dismiss the current view controller
          }
          alertController.addAction(okAction)
          present(alertController, animated: true, completion: nil)
    }
    
    
}


