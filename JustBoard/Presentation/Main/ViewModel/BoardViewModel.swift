//
//  BoardViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class BoardViewModel : MainViewModelType {
    
    private var product_id : String
    private var userId : String?
    private var limit : String
    private var maxLimit : Int
    private var bestBoard : Bool
    private var profileBoard : Bool
    private var bestBoardType : BestCategory?
    private var profileBoardType : ProfilePostCategory?
    var disposeBag: DisposeBag = DisposeBag()
    
    init(product_id: String, userId : String?, limit: String, bestBoard: Bool, profileBoard:Bool, bestBoardType: BestCategory?, profileBoardType: ProfilePostCategory?) {
        self.product_id = product_id
        self.userId = userId
        self.limit = limit
        self.maxLimit = Int(limit)!
        self.bestBoard = bestBoard
        self.profileBoard = profileBoard
        self.bestBoardType = bestBoardType
        self.profileBoardType = profileBoardType
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
        
        // Board Refresh
        NotificationCenter.default.rx.notification(.boardRefresh)
            .withLatestFrom(productIdWithLimit)
            .flatMap { product_id, limit in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: limit, product_id: product_id))
            }
            .enumerated()
            .bind(with: self) { owner, result in
                owner.handleBoardData(result: result, bestBoard: owner.bestBoard, profileBoard: owner.profileBoard,bestBoardType: owner.bestBoardType, profileBoardType: owner.profileBoardType,postData: postData, nextCursor: nextCursor)
            }
            .disposed(by: disposeBag)
        
        //
        input.viewWillAppear
            .withLatestFrom(productIdWithLimit)
            .flatMap { product_id, limit in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: limit, product_id: product_id))
            }
            .enumerated()
            .bind(with: self) { owner, result in
                owner.handleBoardData(result: result, bestBoard: owner.bestBoard, profileBoard: owner.profileBoard,bestBoardType: owner.bestBoardType, profileBoardType: owner.profileBoardType,postData: postData, nextCursor: nextCursor)
            }
            .disposed(by: disposeBag)
        
        input.prefetchItems
            .map { [weak self] items in
                guard let self = self else { return false }
                return items > maxLimit - 5
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
                if page && curosr != InquiryRequest.InquiryRequestDefault.next {
                    nextPage.onNext(curosr)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(nextPage, product_id)
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

    private func handleBoardData(result: (index: Int, element: PrimitiveSequence<SingleTrait, Result<InquiryResponse, AFError>>.Element), bestBoard: Bool, profileBoard : Bool, bestBoardType : BestCategory?, profileBoardType : ProfilePostCategory?, postData: BehaviorRelay<[BoardDataSection]>, nextCursor: PublishSubject<String>) {
        switch result.element {
        case .success(let value):
            
            if let type = bestBoardType {
                let sortedData: [PostResponse]
                let returnData: [PostResponse]
                lazy var maxLength = sortedData.count > InquiryRequest.InquiryRequestDefault.maxPage ? InquiryRequest.InquiryRequestDefault.maxPage : sortedData.count
                
                switch type {
                case .commentSort:
                    sortedData = value.data.sorted { $0.comments.count > $1.comments.count }
                case .likeSort:
                    sortedData = value.data.sorted { $0.likes.count > $1.likes.count }
                case .unlikeSort:
                    sortedData = value.data.sorted { $0.likes2.count > $1.likes2.count }
                }
                returnData = bestBoard ? Array(sortedData[0..<maxLength]) : sortedData
                postData.accept([BoardDataSection(items: returnData)])
                nextCursor.onNext(value.next_cursor)
                
            } else if let type = profileBoardType {
                
                guard let userId = userId else { return }
                let returnData: [PostResponse]
                
                switch type {
                case .myPost:
                    returnData = value.data.filter {
                        $0.creator.userID == userId
                    }
                case .myComment:
                    returnData = value.data.filter {
                        return $0.comments.contains {
                            return $0.creator.userID == userId
                        }
                    }
                case .myFavorite:
                    returnData = value.data.filter {
                        return $0.likes.contains {
                            return $0 == userId
                        }
                    } 
                }
                
                postData.accept([BoardDataSection(items: returnData)])
                nextCursor.onNext(value.next_cursor)
                
            } else {
                postData.accept([BoardDataSection(items: value.data)])
                nextCursor.onNext(value.next_cursor)
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func calculateLikesRatio(post: PostResponse) -> Double {
        return Double(post.likes.count) / Double(post.likes.count + post.likes2.count)
    }

}
