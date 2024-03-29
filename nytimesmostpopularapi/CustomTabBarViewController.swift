//
//  CustomTabBarViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/10/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//
//  Customized tab bar view controller that programatically creates screens for our NYTAPI app
//

import Foundation
import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        print("testing nav controller")
        print(self.navigationController)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("CustomTabBarViewController - viewWillAppear")
        let item1 = ArticleListViewController()
        let icon1 = UITabBarItem(title: "arts", image: UIImage(named: "art.png"), selectedImage: UIImage(named: "art.png"))
        item1.tabBarItem = icon1
        
        let item2 = ArticleListViewController()
        let icon2 = UITabBarItem(title: "world", image: UIImage(named: "world.png"), selectedImage: UIImage(named: "world.png"))
        item2.tabBarItem = icon2
        
        let item3 = ArticleListViewController()
        let icon3 = UITabBarItem(title: "health", image: UIImage(named: "health.png"), selectedImage: UIImage(named: "health.png"))
        item3.tabBarItem = icon3
        
        let controllers = [item1, item2, item3]
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}