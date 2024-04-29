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
    var limit = Int(InquiryRequest.InquiryRequestDefault.limit)!
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
        let questionButtonTap : ControlEvent<Void>
        let prefetchItems : Observable<Int>
    }
    
    struct Output {
        let viewWillAppear : Driver<Bool>
        let questionButtonTap : Driver<Void>
        let boardDataListSubject : BehaviorRelay<[BoardDataSection]>
        let postData : PublishSubject<[PostResponse]>
        let nextPost : PublishSubject<[PostResponse]>
    }
    
    func transform(input: Input) -> Output {
        let boardDataListSubject = BehaviorRelay(value: [BoardDataSection]())
        let postData = PublishSubject<[PostResponse]>()
        let nextPost = PublishSubject<[PostResponse]>()
        let nextPageValid = BehaviorSubject<Bool>(value: false)
        let nextCursor = PublishSubject<String>()
        let nextPage = PublishSubject<String>()
        
        input.viewWillAppear
            .flatMap { _ in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: InquiryRequest.InquiryRequestDefault.limit,
                                                                        product_id: ""))
                // nhj_test gyjw_all
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    boardDataListSubject.accept([BoardDataSection(items: value.data)])
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
        
        nextPage
            .debug("NextPage ✅")
            .flatMap { cursor in
                return NetworkManager.shared.post(query: InquiryRequest(next: cursor,
                                                                        limit: InquiryRequest.InquiryRequestDefault.limit,
                                                                        product_id: ""))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.limit += Int(InquiryRequest.InquiryRequestDefault.limit)!
                    postData.onNext(value.data)
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
            boardDataListSubject : boardDataListSubject,
            postData: postData,
            nextPost: nextPost
        )
    }
}
