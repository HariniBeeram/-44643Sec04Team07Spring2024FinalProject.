//
//  TableBookingViewController.swift
//  SHA-STORY
//
//  Created by Muthyala,Sai Ram Reddy on 4/12/24.
//

import UIKit
import ARKit
import SceneKit
class TableBooking: UIViewController,ARSCNViewDelegate {

    @IBOutlet weak var arView: ARSCNView!
    var tableNodes: [SCNNode] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           // Set the view's delegate
           arView.delegate = self
           
           // Create a new scene
           let scene = SCNScene()
           
           // Set the scene to the view
           arView.scene = scene
           
           // Add tap gesture recognizer
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
           arView.addGestureRecognizer(tapGesture)
           
           // Create a session configuration
           let configuration = ARWorldTrackingConfiguration()
           
           // Run the view's session
           arView.session.run(configuration)
           
           // Add tables to the scene
           addTables()
           
           // Load booking state
          // loadBookingState()
       }
       
       @objc func handleTap(_ gesture: UITapGestureRecognizer) {
           // Get the location of the tap gesture
           let tapLocation = gesture.location(in: arView)
           
           // Perform hit test to find out which object was tapped
           let hitTestResults = arView.hitTest(tapLocation)
           
           // Check if any table nodes were hit
           for result in hitTestResults {
               if tableNodes.contains(result.node) {
                   // Handle the tap on the table node
                   if let tableIndex = tableNodes.firstIndex(of: result.node) {
                       // Simulate booking by changing the color of the table node
                       result.node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                       // Update booking state
                       //UserDefaults.standard.set(true, forKey: "Table\(tableIndex)")
                       print("Table \(tableIndex + 1) booked!")
                   }
               }
           }
       }
       
       func addTables() {
           // Example table positions
           let tablePositions: [SCNVector3] = [
               SCNVector3(0, 0, -5),
               SCNVector3(2, 0, -5),
               SCNVector3(-2, 0, -5)
           ]
           
           // Load the table model (assuming a cube representing a big-sized table)
           let tableNode = SCNNode(geometry: SCNBox(width: 2.0, height: 1.0, length: 2.0, chamferRadius: 0.1)) // Adjust size as needed
           tableNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green // Initial color
           
           // Add tables to the scene at specified positions
           for position in tablePositions {
               let clonedTableNode = tableNode.clone()
               clonedTableNode.position = position
               arView.scene.rootNode.addChildNode(clonedTableNode)
               tableNodes.append(clonedTableNode) // Add the table node to the array
           }
       }
       
       func loadBookingState() {
           for (index, node) in tableNodes.enumerated() {
               let isBooked = UserDefaults.standard.bool(forKey: "Table\(index)")
               if isBooked {
                   // Change the color of the table node to indicate it's booked
                   node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
               }
           }
       }
   }
