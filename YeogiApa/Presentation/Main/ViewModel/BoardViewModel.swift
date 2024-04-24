//
//  BoardViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardViewModel : MainViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
        let questionButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let questionButtonTap : Driver<Void>
        let postData : PublishSubject<[PostResponse]>
    }
    
    func transform(input: Input) -> Output {
        
        let postData = PublishSubject<[PostResponse]>()
        
        input.viewWillAppear
            .flatMap { _ in
                return NetworkManager.shared.post(query: InquiryRequest(next: "0", limit: "30", product_id: "gyjw_all"))
                // nhj_test gyjw_all
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    postData.onNext(value.data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            questionButtonTap: input.questionButtonTap.asDriver(),
            postData: postData
        )
    }
}
