//
//  BoardListViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/5/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class BoardListViewModel : MainViewModelType {
    private var product_id : String
    private var limit : String
    var disposeBag: DisposeBag = DisposeBag()
    
    init(product_id: String) {
        self.product_id = product_id
        self.limit = InquiryRequest.InquiryRequestDefault.maxLimit
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
    }
    
    struct Output {
        let postData : BehaviorRelay<[BoardListDataSection]>
    }
    
    func transform(input: Input) -> Output {
        
        let product_id = BehaviorSubject<String>(value: product_id)
        let limit = BehaviorSubject<String>(value: String(limit))
        let postData = BehaviorRelay(value: [BoardListDataSection]())
        let productIdWithLimit = Observable.combineLatest(product_id,limit)
        
        productIdWithLimit
            .flatMap { product_id, limit in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: limit,
                                                                        product_id: product_id))
            }
            .bind(with: self) { owner, result in
                
                switch result {
                case .success(let value):
                    postData.accept([BoardListDataSection(items: value.postList)])
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            postData:postData
        )
    }
}
