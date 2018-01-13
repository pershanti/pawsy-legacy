//
//  NewDogPageViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/10/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class NewDogPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
    
    lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "nd0"),
            self.getViewController(withIdentifier: "nd1"),
            self.getViewController(withIdentifier: "nd2"),
            self.getViewController(withIdentifier: "nd3"),
            self.getViewController(withIdentifier: "nd4")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages.first{
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        
    }







}



