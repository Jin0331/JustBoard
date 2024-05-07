//
//  UIApplication+Extension.swift
//  JustBoard
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit

extension UIApplication {
    /*function will return reference to tabbarcontroller */
    func tabbarController() -> UIViewController? {
        guard let vcs = self.keyWindow?.rootViewController?.children else { return nil }
        for vc in vcs {
            if  let _ = vc as? MainTabBarController {
                return vc
            }
        }
        return nil
    }
}
