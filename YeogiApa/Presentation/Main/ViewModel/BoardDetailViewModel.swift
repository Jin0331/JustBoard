//
//  BoardDetailViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardDetailViewModel : MainViewModelType {
    
    var postData : BehaviorSubject<PostResponse>
    var disposeBag: DisposeBag = DisposeBag()
    
    init(_ receiveData: PostResponse) {
        self.postData = BehaviorSubject<PostResponse>(value: receiveData)
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
        let commentText : ControlProperty<String>
        let commentComplete : ControlEvent<Void>
    }
    
    struct Output {
        let viewWillAppear : Driver<Bool>
        let commentButtonUI : Driver<Bool>
        let postData : BehaviorSubject<PostResponse>
        let postCommentData : PublishSubject<PostResponse>
    }
    
    func transform(input: Input) -> Output {
        
        let commentButtonEnable = BehaviorSubject<Bool>(value: false)
        let commentRequestModel = PublishSubject<CommentRequest>()
        let postCommentData = PublishSubject<PostResponse>()
        
        input.commentText
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(with: self) { owner, text in
                commentButtonEnable.onNext(!text.isEmpty)
                commentRequestModel.onNext(CommentRequest(content: text))
            }
            .disposed(by: disposeBag)
        
        let commentRequest = Observable.combineLatest(commentRequestModel, postData)
        
        input.commentComplete
            .withLatestFrom(commentRequest)
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .flatMap {
                return NetworkManager.shared.comment(query: $0, postId: $1.postID)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let postResponse):
                    postCommentData.onNext(postResponse)
                    print(postResponse)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            viewWillAppear:input.viewWillAppear.asDriver(onErrorJustReturn: false),
            commentButtonUI: commentButtonEnable.asDriver(onErrorJustReturn: false),
            postData:postData,
            postCommentData: postCommentData
        )
    }
}
