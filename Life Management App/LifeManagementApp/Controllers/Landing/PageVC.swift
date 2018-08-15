//
//  PageVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/6/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    lazy var VCArr: [UIViewController] = {
        return [self.VCInstance(name:"FirstScreen"),
                self.VCInstance(name:"SecondScreen"),
                self.VCInstance(name:"ThirdScreen"),
                self.VCInstance(name:"FourthScreen")]
    }()
    
    private func VCInstance(name: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let firstVC = VCArr.first{
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
            }else if view is UIPageControl{
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else{
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard previousIndex < VCArr.count else{
            return nil
        }
        
        return VCArr[previousIndex]
    }
    

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            return nil
        }
        
        guard nextIndex < VCArr.count else{
            return nil
        }
        
        return VCArr[nextIndex]
    }
    
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int{
        
        return VCArr.count
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArr.index(of: firstViewController) else{
            return 0
        }
        
        return firstViewControllerIndex
    }
    
}
