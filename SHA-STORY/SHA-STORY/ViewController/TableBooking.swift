//
//  TableBookingViewController.swift
//  SHA-STORY
//
//  Created by Muthyala,Sai Ram Reddy on 4/12/24.
//

import UIKit
import ARKit
import SceneKit
class TableBooking: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var reserve: UIButton!
    
    @IBOutlet weak var imgView: SCNView!
    var tableNode: SCNNode? // Keep reference to the table node

        override func viewDidLoad() {
            print("username: \(AppDelegate.username)")
            super.viewDidLoad()
            guard let url = Bundle.main.url(forResource: "restaurant3", withExtension: "usdz"),
                         let scene = try? SCNScene(url: url) else {
                       fatalError("Failed to load the USDZ file.")
                   }

            // Set the scene to the view
            imgView.scene = scene
            imgView.backgroundColor = UIColor.white // Set background color if needed
            imgView.autoenablesDefaultLighting = true // Enable default lighting
            imgView.isUserInteractionEnabled = true
            // Allows the user to manipulate the camera
            imgView.allowsCameraControl = true
       
            imgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            print("scene\(scene)")
           // let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
            //imgView.addGestureRecognizer(pinchGesture)
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
                  imgView.addGestureRecognizer(pinchGesture)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 imgView.addGestureRecognizer(tapGesture)
        }
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
           guard let scene = imgView.scene else { return }

           // Get the current scale of the scene's root node
           let currentScale = scene.rootNode.scale

           // Calculate the new scale based on the pinch gesture's scale
           let newScale = SCNVector3(currentScale.x * Float(gesture.scale),
                                     currentScale.y * Float(gesture.scale),
                                     currentScale.z * Float(gesture.scale))

           // Apply the new scale to the scene's root node
           scene.rootNode.scale = newScale

           // Reset the gesture's scale to 1 to prevent cumulative scaling
           gesture.scale = 1
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
}
extension FloatingPoint {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

