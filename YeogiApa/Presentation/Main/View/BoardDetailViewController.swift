//
//  BoardDetailViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit

class BoardDetailViewController: RxBaseViewController {

    private let mainView = BoardDetailView()
    var parentCoordinator : BoardCoordinator?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        tabBarController?.tabBar.isHidden = true
    }
    
    deinit {
        print(#function, "- BoardDetailViewController ✅")
    }
}