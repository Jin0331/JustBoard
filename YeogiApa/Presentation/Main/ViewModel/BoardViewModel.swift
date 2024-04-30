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

    private var limit = Int(InquiryRequest.InquiryRequestDefault.limit)!
    private var product_id : String
    var disposeBag: DisposeBag = DisposeBag()
    
    init(_ product_id: String) {
        self.product_id = product_id
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
        let postData = BehaviorRelay(value: [BoardDataSection]())
        let nextPost = PublishSubject<[PostResponse]>()
        let nextPageValid = BehaviorSubject<Bool>(value: false)
        let nextCursor = PublishSubject<String>()
        let nextPage = PublishSubject<String>()
        
        input.viewWillAppear
            .withLatestFrom(product_id)
            .flatMap { product_id in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: InquiryRequest.InquiryRequestDefault.limit,
                                                                        product_id: product_id))
                // nhj_test gyjw_all
            }
            .enumerated()
            .bind(with: self) { owner, result in
//                print(result.index, "event index ✅", postData.value, "current Post ✅")
                switch result.element {
                case .success(let value):
                    postData.accept([BoardDataSection(items: value.data)])
                    nextCursor.onNext(value.next_cursor)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.prefetchItems
            .map { [weak self] items in
                guard let self = self else { return false }
                print(items, "제한 ✅:", limit, items > limit - 5)
                return items > limit - 2
            }
            .bind(with: self) { owner, valid in
                nextPageValid.onNext(valid)
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
