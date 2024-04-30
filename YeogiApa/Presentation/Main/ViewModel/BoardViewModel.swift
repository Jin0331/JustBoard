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

    private var bestBoard : Bool
    private var limit : String /*Int(InquiryRequest.InquiryRequestDefault.limit)!*/
    private var maxLimit : Int
    private var product_id : String
    var disposeBag: DisposeBag = DisposeBag()
    
    init(product_id: String, limit: String, bestBoard: Bool) {
        self.product_id = product_id
        self.limit = limit
        self.maxLimit = Int(limit)!
        self.bestBoard = bestBoard
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
        let questionButtonTap : ControlEvent<Void>
        let prefetchItems : Observable<Int>
    }
    
    struct Output {
        let viewWillAppear : Driver<Bool>
        let questionButtonTap : Driver<Void>
        let postData : BehaviorRelay<[BoardDataSection]>
        let nextPost : PublishSubject<[PostResponse]>
    }
    
    func transform(input: Input) -> Output {
        let product_id = BehaviorSubject<String>(value: product_id)
        let limit = BehaviorSubject<String>(value: String(limit))
        let postData = BehaviorRelay(value: [BoardDataSection]())
        let nextPost = PublishSubject<[PostResponse]>()
        let nextPageValid = BehaviorSubject<Bool>(value: false)
        let nextCursor = PublishSubject<String>()
        let nextPage = PublishSubject<String>()
        
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
                    
                    let sortedData = owner.bestBoard ? value.data.sorted {
                        $0.comments.count > $1.comments.count } : value.data
                    let maxLength = sortedData.count > 30 ? 30 : sortedData.count - 1
                    
                    let returnPost = owner.bestBoard ? Array(sortedData[0...maxLength]) : sortedData
                    
                    postData.accept([BoardDataSection(items: returnPost)])
                    nextCursor.onNext(value.next_cursor)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.prefetchItems
            .map { [weak self] items in
                guard let self = self else { return false }                
                print(items, "제한 ✅:", maxLimit, maxLimit > maxLimit - 5)
                return items > maxLimit - 2
            }
            .bind(with: self) { owner, valid in
                if !owner.bestBoard {
                    nextPageValid.onNext(valid)
                }

            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(nextPageValid, nextCursor)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { page, curosr in
                print(page, curosr, "current ❗️")
                if page && curosr != InquiryRequest.InquiryRequestDefault.next {
                    print(page, curosr, "nextpage ✅")
                    nextPage.onNext(curosr)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(nextPage, product_id)
            .debug("NextPage ✅")
            .flatMap { cursurWithProductId in
                return NetworkManager.shared.post(query: InquiryRequest(next: cursurWithProductId.0,
                                                                        limit: InquiryRequest.InquiryRequestDefault.limit,
                                                                        product_id: cursurWithProductId.1))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    let currentData = postData.value
                    postData.accept(currentData + [BoardDataSection(items: value.data)])
                    nextCursor.onNext(value.next_cursor)
                    nextPageValid.onNext(false)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            viewWillAppear: input.viewWillAppear.asDriver(onErrorJustReturn: false),
            questionButtonTap: input.questionButtonTap.asDriver(),
            postData: postData,
            nextPost: nextPost
        )
    }
}
