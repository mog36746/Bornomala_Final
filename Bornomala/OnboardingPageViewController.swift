//
//  OnboardingPageViewController.swift
//  Bornomala
//
//  Created by MI on 4/2/20.
//  Copyright © 2020 Mog. All rights reserved.
//

import UIKit

protocol OnboardingPageViewDelegate{
    func didUpdateIndex(currentIndex: Int)
}

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let images = ["one","two","three"]
    let headings = ["Form Book","With Camera","Bring Reality"]
    let subheadings = ["Lorem epsum lorem epsum Lorem epsum lorem epsum","Capcom lorem Lorem epsum lorem epsum Lorem epsum lorem epsum","Capsicum Lorem epsum lorem epsum Lorem epsum"]
    var currentIndex = 0
    var onboardingPageViewDelegate : OnboardingPageViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        // Do any additional setup after loading the view.
        if let contentViewController = contentViewController(at: 0){
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int)-> OnboardingContentViewController? {
        
        if index < 0 || index >= headings.count {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let contentViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingContent") as? OnboardingContentViewController {
            contentViewController.index = index
            contentViewController.image = images[index]
            contentViewController.heading = headings[index]
            contentViewController.subHeading = subheadings[index]
            
            return contentViewController
        }
        return nil
    }
    
    func forwardPage(){
        currentIndex += 1
        if let contentViewController = contentViewController(at: currentIndex){
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
            print("@ page view controller")
        }
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
                currentIndex = contentController.index
                
                onboardingPageViewDelegate?.didUpdateIndex(currentIndex: currentIndex)
            }
        }
    }

   

}

