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
    private lazy var viewModel = QuestionViewModel(textView: mainView.contentsTextView)
    weak var parentCoordinator : QuestionCoordinator?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        // 게시글 입력이 완료되었을 때
        
                
        let input = QuestionViewModel.Input(completeButtonTap: mainView.searchButtonItem.rx.tap,
                                            contentsText: mainView.contentsTextView.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        output.writeComplete
            .drive(with: self) { owner, _ in
                print("hi")
            }
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
    }
    
    deinit {
        print(#function, "QuestionViewController 🔆")
    }
}
