//
//  TableBookingViewController.swift
//  SHA-STORY
//
//  Created by Muthyala,Sai Ram Reddy on 4/12/24.
//

import UIKit
import ARKit
import SceneKit
class TableBooking: UIViewController {

       
    @IBOutlet weak var imgView: SCNView!
    var tableNode: SCNNode? // Keep reference to the table node

        override func viewDidLoad() {
            super.viewDidLoad()
            guard let url = Bundle.main.url(forResource: "room", withExtension: "usdz"),
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
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 imgView.addGestureRecognizer(tapGesture)
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
                   imgView.addGestureRecognizer(pinchGesture)
        }
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let scene = imgView.scene else { return }
        print("Pinch gesture recognized!")
        if gesture.state == .changed {
            // Calculate the new scale based on pinch gesture
            let newScaleX = scene.rootNode.scale.x * Float(gesture.scale)
                    let newScaleY = scene.rootNode.scale.y * Float(gesture.scale)
                    let newScaleZ = scene.rootNode.scale.z * Float(gesture.scale)

                    // Limit the scale to prevent zooming too close or too far
                    let minScale: Float = 0.5
                    let maxScale: Float = 2.0
                    let clampedScaleX = min(max(newScaleX, minScale), maxScale)
                    let clampedScaleY = min(max(newScaleY, minScale), maxScale)
                    let clampedScaleZ = min(max(newScaleZ, minScale), maxScale)

                    // Apply the new scale to the root node
                    scene.rootNode.scale = SCNVector3(clampedScaleX, clampedScaleY, clampedScaleZ)

                    // Reset gesture scale for the next pinch gesture
                    gesture.scale = 1.0
                }
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Get the location of the tap in the scene view
        let location = gesture.location(in: imgView)
        let hitTestResults = imgView.hitTest(location, options: nil)
        
        // Check if a node was tapped
        if let tappedNode = hitTestResults.first?.node {
            // Get the name of the tapped node
            let nodeName = tappedNode.name ?? "Unnamed Node"
            print("Tapped node name: \(nodeName)")
            let newColor = UIColor.red
                   tappedNode.geometry?.firstMaterial?.diffuse.contents = newColor
        }
    }
}
