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
        
        configureNavigation()
        configureView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureItemDesign(tabBar: tabBar)
    }
    
    private func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    private func configureNavigation() {
        // back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}
