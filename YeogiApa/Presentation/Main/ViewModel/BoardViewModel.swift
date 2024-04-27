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
    var limit = 30
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
        let questionButtonTap : ControlEvent<Void>
        let prefetchItems : Observable<Int>
    }
    
    struct Output {
        let viewWillAppear : Driver<Bool>
        let questionButtonTap : Driver<Void>
        let postData : PublishSubject<[PostResponse]>
        let nextPost : PublishSubject<[PostResponse]>
    }
    
    func transform(input: Input) -> Output {
        
        let postData = PublishSubject<[PostResponse]>()
        let nextPost = PublishSubject<[PostResponse]>()
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
                    postData.onNext(value.data)
                    nextCursor.onNext(value.next_cursor)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        let goNextPage = input.prefetchItems
            .map { [weak self] items in
                guard let self = self else { return false }
                print(items, "제한 ✅:", limit, items > limit - 2)
                return items > limit - 2
            }
        
        Observable.combineLatest(goNextPage, nextCursor)
            .bind { goNextPage, nextCursor in
                
                if goNextPage && nextCursor != InquiryRequest.InquiryRequestDefault.next {
                    print(goNextPage, nextCursor, "nextpage ✅")
                    nextPage.onNext(nextCursor)
                } else {
                    print("Cursor 없음 ! 🥲")
                }
            }
            .disposed(by: disposeBag)
        
        nextPage
            .flatMap { cursor in
                return NetworkManager.shared.post(query: InquiryRequest(next: cursor,
                                                                        limit: InquiryRequest.InquiryRequestDefault.limit,
                                                                        product_id: ""))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.limit += 30
                    postData.onNext(value.data)
                    nextCursor.onNext(value.next_cursor)
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
