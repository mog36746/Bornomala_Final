//
//  ViewController.swift
//  Bornomala
//
//  Created by MI on 4/2/20.
//  Copyright © 2020 Mog. All rights reserved.
//


import UIKit
import ARKit
import SceneKit
class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var shutterView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    
    var n1fNode: SCNNode?
    var n1bNode: SCNNode?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {

        let n1fScene = SCNScene(named: "ArtScene.scnassets/s1f.scn")
        n1fNode = n1fScene?.rootNode

        let n1bScene = SCNScene(named: "ArtScene.scnassets/s2b.scn")
        n1bNode = n1bScene?.rootNode

        // Set the view's delegate
        sceneView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if   !defaults.bool(forKey: "isShowOn") {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = (storyboard.instantiateViewController(withIdentifier: "OnboardingMain") as? OnboardingViewController)!
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)

        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "n1", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            print("Sucessfully")
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        print("Track")
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.1)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            print("Inside")
            
//            if let shapeNode = n1bNode {
//                node.addChildNode(shapeNode)
//            }
            
            var shapNode:SCNNode?
            if imageAnchor.referenceImage.name == "n1f" {
                shapNode = n1fNode
                print("now")
            } else {
                print("cow")
                shapNode = n1bNode
            }
            
            guard let shap = shapNode else {
                return nil
            }
            
            node.addChildNode(shap)
        }
        return node
    }
    
    
    // MARK: - Action
    
    
    @IBAction func onSnapButtonPress(_ sender: Any) {
//        shutterView.alpha = 1.0
//        shutterView.isHidden = false
//        UIView.animate(withDuration: 1.0, animations: {
//            self.shutterView.alpha = 0.0
//        }) {(finished) in
//            self.shutterView.isHidden = true
//            UIImageWriteToSavedPhotosAlbum(self.sceneView.snapshot(), nil, nil, nil)
//        }
        
        shutterView.alpha = 1.0
        shutterView.isHidden = false
        
        if let soundURL = Bundle.main.url(forResource: "shutter", withExtension: "mp3") {
            var mySound : SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            AudioServicesPlayAlertSound(mySound)
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            self.shutterView.alpha = 0.0
        }) { (finished) in
            self.shutterView.isHidden = true
            UIImageWriteToSavedPhotosAlbum(self.sceneView.snapshot(), nil, nil, nil)
        }
    }
    
}

