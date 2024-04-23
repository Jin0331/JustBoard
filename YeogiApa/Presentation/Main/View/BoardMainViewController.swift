//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class BoardMainViewController: RxBaseViewController {
    
    private let mainView = BoardMainView()
    private let viewModel = BoardMainViewModel()
    var parentCoordinator : BoardCoordinator?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temp = NetworkManager.shared.post(query: InquiryRequest(next: "0", limit: "30", product_id: "gyjw_all"))
        
        temp.asObservable()
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    override func bind() {
        let input = BoardMainViewModel.Input(questionButtonTap: mainView.questionButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.questionButtonTap
            .drive(with: self) { owner, _ in
                print("question Button Tap ✅")
                owner.parentCoordinator?.toQuestion()
            }
            .disposed(by: disposeBag)
    }
}
