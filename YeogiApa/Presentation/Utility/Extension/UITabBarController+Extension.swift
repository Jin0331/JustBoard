//
//  UITabBarController+Extension.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import UIKit

extension UITabBarController {
    func configureItemDesing(tabBar : UITabBar) {
        
        tabBar.tintColor = DesignSystem.commonColorSet.gray
        tabBar.barTintColor = DesignSystem.commonColorSet.white
        
        // item 디자인
        if let item = tabBar.items {
            //TODO: - Active, Inactive 구현해야됨. 지금은 Inactive 상태
            item[0].image = DesignSystem.tabbarImage.first
            item[0].title = "홈"
            
            item[1].image = DesignSystem.tabbarImage.second
            item[1].title = "더 보기"
        }
    }
}

