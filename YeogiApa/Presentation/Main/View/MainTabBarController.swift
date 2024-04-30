//
//  MainTabBarController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureItemDesign(tabBar: tabBar)
    }
    
    private func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.white
    }
}
