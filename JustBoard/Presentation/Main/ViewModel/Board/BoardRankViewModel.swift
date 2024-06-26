//
//  BoardRankViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardRankViewModel : MainViewModelType {
    private var limit : String
    private var product_id : String
    var disposeBag: DisposeBag = DisposeBag()
    
    init(product_id: String, limit: String) {
        self.product_id = product_id
        self.limit = limit
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
        let userProfileInquiry : PublishSubject<String>
    }
    
    struct Output {
        let postData : BehaviorRelay<[BoardRankDataSection]>
        let userProfile : Observable<(userPostId:[String], userNickname:String)>
    }
    
    func transform(input: Input) -> Output {
        let product_id = BehaviorSubject<String>(value: product_id)
        let limit = BehaviorSubject<String>(value: String(limit))
        let postData = BehaviorRelay(value: [BoardRankDataSection]())
        let userPostId = PublishSubject<[String]>()
        let userNickname = PublishSubject<String>()
        let productIdWithLimit = Observable.combineLatest(product_id,limit)
        
        input.viewWillAppear
            .withLatestFrom(productIdWithLimit)
            .flatMap { product_id, limit in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: limit,
                                                                        product_id: product_id))
            }
            .enumerated()
            .bind(with: self) { owner, result in
                
                switch result.element {
                case .success(let value):
                    postData.accept([BoardRankDataSection(items: Array(value.postRank[0..<20]))])
                    NotificationCenter.default.post(name: .boardRefresh, object: nil)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.userProfileInquiry
            .flatMap { userId in
                return NetworkManager.shared.profile(userId: userId)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("BoardMainViewModel userProfileInquiry ✅")
                    userPostId.onNext(value.posts)
                    userNickname.onNext(value.nick)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            postData : postData,
            userProfile:  Observable.zip(userPostId, userNickname)
                                    .map { (userPostId: $0, userNickname: $1) }
        )
    }
}
