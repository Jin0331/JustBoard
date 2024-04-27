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
        let viewWillAppear : Driver<Bool>
        let questionButtonTap : Driver<Void>
        let postData : PublishSubject<[PostResponse]>
    }
    
    func transform(input: Input) -> Output {
        
        let postData = PublishSubject<[PostResponse]>()
        
        input.viewWillAppear
            .flatMap { _ in
                return NetworkManager.shared.post(query: InquiryRequest(next: "0", limit: "100", product_id: "nhj_test"))
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
            viewWillAppear:input.viewWillAppear.asDriver(onErrorJustReturn: false),
            questionButtonTap: input.questionButtonTap.asDriver(),
            postData: postData
        )
    }
}
