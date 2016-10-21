//
//  NaviagtionTableViewController.swift
//  Smashtag
//
//  Created by Winnie on 22/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class NaviagtionTableViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        if self.navigationController?.viewControllers.count > 1 {
            let rootButton = UIBarButtonItem(title: Storyboard.RootButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NaviagtionTableViewController.popToRoot))
            self.navigationItem.rightBarButtonItem = rootButton
        }
    }
    
    func popToRoot() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
