//
//  BoardMainViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardMainViewModel : MainViewModelType {
    
    private var limit : String
    private var product_id : String
    var disposeBag: DisposeBag = DisposeBag()
    
    init(product_id: String, limit: String) {
        self.product_id = product_id
        self.limit = limit
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
    }
    
    struct Output {
        let postData : BehaviorRelay<[BoardRankDataSection]>
        let viewWillAppear : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let product_id = BehaviorSubject<String>(value: product_id)
        let limit = BehaviorSubject<String>(value: String(limit))
        let postData = BehaviorRelay(value: [BoardRankDataSection]())
        
        let productIdWithLimit = Observable.combineLatest(product_id,limit)
        
        input.viewWillAppear
            .withLatestFrom(productIdWithLimit)
            .flatMap { product_id, limit in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: limit,
                                                                        product_id: product_id))
                // nhj_test gyjw_all
            }
            .enumerated()
            .bind(with: self) { owner, result in
                
                switch result.element {
                case .success(let value):
                    postData.accept([BoardRankDataSection(items: value.postRank)])
                    
                    print(value.userRankData)
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            postData : postData,
            viewWillAppear: input.viewWillAppear.asDriver(onErrorJustReturn: false)
        )
    }
}
