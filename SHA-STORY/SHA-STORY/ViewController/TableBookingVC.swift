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

    @IBOutlet weak var reserve: UIButton!
    
    @IBOutlet weak var imgView: SCNView!
    var tableNode: SCNNode? // Keep reference to the table node
    var tableNodes:[String] = ["Object_20","Object_124","Object_98","Object_194","Object_150","Object_72","Object_592","Object_615"]
        override func viewDidLoad() {
            print("username: \(AppDelegate.username)")
            super.viewDidLoad()
            guard let url = Bundle.main.url(forResource: "restaurant3", withExtension: "usdz"),
                         let scene = try? SCNScene(url: url) else {
                       fatalError("Failed to load the USDZ file.")
                   }
            imgView.scene = scene
            imgView.backgroundColor = UIColor.white // Set background color if needed
            imgView.autoenablesDefaultLighting = true // Enable default lighting
            imgView.isUserInteractionEnabled = true
            // Allows the user to manipulate the camera
            imgView.allowsCameraControl = true
       
            imgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            print("scene\(scene)")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 imgView.addGestureRecognizer(tapGesture)
            
        }
   
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Get the location of the tap in the scene view
        let location = gesture.location(in: imgView)
        let hitTestResults = imgView.hitTest(location, options: nil)
        
        // Check if a node was tapped
        if let tappedNode = hitTestResults.first?.node {
            let nodeName = tappedNode.name ?? "Unnamed Node"
            print("Tapped node name: \(nodeName)")
            let newColor = UIColor.red
                   tappedNode.geometry?.firstMaterial?.diffuse.contents = newColor
        }
    }
    func handleTableSelection(selectedDate: Date, selectedTime: String, reservedTables: [String]) {
        let db = Firestore.firestore()
          // Construct table reservation object
          let reservationData: [String: Any] = [
              "date": selectedDate,
              "time": selectedTime,
              "reservedTables": reservedTables
          ]
          
          // Format document ID using selected date and time
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let documentID = dateFormatter.string(from: selectedDate) + "_" + selectedTime
          
          // Add table reservation data to Firestore
          db.collection("Table Reservation").document(documentID).setData(reservationData) { error in
              if let error = error {
                  print("Error adding table reservation: \(error.localizedDescription)")
              } else {
                  print("Table reservation added successfully!")
              }
          }
      }
      
}

