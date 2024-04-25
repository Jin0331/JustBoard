//
//  BoardDetailViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

final class BoardDetailViewController: RxBaseViewController {

    private let mainView = BoardDetailView()
    private let viewModel : BoardDetailViewModel
    var parentCoordinator : BoardCoordinator?
    
    override func loadView() {
        view = mainView
        tabBarController?.tabBar.isHidden = true
    }
    
    init(postResponse : PostResponse) {
        self.viewModel = BoardDetailViewModel(postResponse)
    }

    override func bind() {
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .bind(with: self) { owner, _ in
                owner.mainView.scrollView.isScrollEnabled = true
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .bind(with: self) { owner, _ in
                owner.mainView.scrollView.isScrollEnabled = false
            }
            .disposed(by: disposeBag)

        
        let input = BoardDetailViewModel.Input(
            viewWillAppear: rx.viewDidAppear
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                
            }
            .disposed(by: disposeBag)
        
        output.postData
            .bind(with: self) { owner, postData in
                owner.navigationItem.title = postData.title
                owner.mainView.updateUI(postData)
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print(#function, "- BoardDetailViewController ✅")
    }
}
