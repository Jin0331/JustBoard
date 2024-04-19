//
//  QuestionViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestionViewController: RxBaseViewController {
    
    private let mainView = QuestionView()
    weak var parentCoordinator : QuestionCoordinator?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        navigationItem.rightBarButtonItem?.rx
            .tap
            .bind(with: self, onNext: { owner, _ in
                print("hi")
            })
            .disposed(by: disposeBag)
    }
    
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.rightBarButtonItem = mainView.searchButtonItem
    }
    
    override func configureView() {
        super.configureView()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainView.titleTextField.alignTextVerticallyInContainer()
        mainView.contentsTextView.alignTextVerticallyInContainer()
    }
    
    deinit {
        print(#function, "QuestionViewController 🔆")
    }
}
