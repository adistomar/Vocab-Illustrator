//
//  TabBarRootViewController.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit

class TabBarRootViewController: UITabBarController, UITabBarControllerDelegate {
    
    var dataController: DataController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedViewController = selectedViewController {
            injectViewControllerWithDataController(viewController: selectedViewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func injectViewControllerWithDataController(viewController: UIViewController) {
        if let viewController = viewController as? CoreDataStackViewController {
            viewController.dataController = dataController
        } else if let viewController = (viewController as? UINavigationController)?.topViewController as? CoreDataStackViewController {
            viewController.dataController = dataController
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(dataController)
        injectViewControllerWithDataController(viewController: viewController)
        return true
    }
    
}
