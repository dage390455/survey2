//
//  RootNavController.swift
//  SensoroCity
//
//  Created by David Yang on 2018/9/27.
//  Copyright © 2018 Sensoro. All rights reserved.
//

import UIKit

class RootNavController: UINavigationController {

    var islightContent = false {
        
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self;
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if !islightContent {
            return UIStatusBarStyle.default
        }
        return UIStatusBarStyle.lightContent
    }
}

extension RootNavController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 {
                return false;
            }
            if let visibleVC = self.visibleViewController, let firstVC = self.viewControllers.first, visibleVC == firstVC {
                return false;
            }
        }
        return true;
    }
}


