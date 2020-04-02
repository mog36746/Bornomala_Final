//
//  OnboardingViewController.swift
//  Bornomala
//
//  Created by MI on 4/2/20.
//  Copyright © 2020 Mog. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, OnboardingPageViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var skipButton: UIButton!
    
    var pageController : OnboardingPageViewController?
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func didUpdateIndex(currentIndex: Int) {
        
        updateUI()
    }
    @IBAction func nextPage(_ sender: UIButton) {
        if let index = pageController?.currentIndex{
            print("Next clicked for \(index)")
            switch index{
            case 0...1:
                pageController?.forwardPage()
            case 2:
                dismiss(animated: true, completion: nil)
            default:break
            }
        }
        updateUI()
    }
    
    @IBAction func skip(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func updateUI(){
        if let index = pageController?.currentIndex{
            switch index{
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("Start", for: .normal)
                skipButton.isHidden = true
            default:break
            }
            pageControl.currentPage = index
            
        }
        defaults.set(true, forKey: "isShowOn")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if let controller = destination as? OnboardingPageViewController {
            pageController = controller
            pageController?.onboardingPageViewDelegate = self
        }
    }

}

