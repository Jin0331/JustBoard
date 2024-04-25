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
        let commentPost : PublishSubject<Comment>
        let updatedPost : PublishSubject<PostResponse>
        let commentComplete : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let commentButtonEnable = BehaviorSubject<Bool>(value: false)
        let commentRequestModel = PublishSubject<CommentRequest>()
        let postCommentData = PublishSubject<Comment>()
        let updatedPostData = PublishSubject<PostResponse>()
        let commentComplete = PublishSubject<Bool>()
        
        input.commentText
            .bind { text in
                commentButtonEnable.onNext(!text.isEmpty)
                commentRequestModel.onNext(CommentRequest(content: text))
            }
            .disposed(by: disposeBag)
        
        let commentRequest = Observable.combineLatest(commentRequestModel, postData)
        let commentResponse = input.commentComplete
            .withLatestFrom(commentRequest)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                NetworkManager.shared.comment(query: $0, postId: $1.postID)
            }.share()
        
        // Comment에서 에러 발생시 추적을 위함
        commentResponse
            .bind(with: self) { owner, result in
                switch result {
                case .success(let commentResponse):
                    postCommentData.onNext(commentResponse)
                    print(commentResponse, "✅ Comment Response")
                case .failure(let error):
                    print(error, "✅ CommentResponse Error")
                }
            }
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(commentResponse, postData)
            .map { $0.1.postID }
            .flatMap {
                NetworkManager.shared.post(postId: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let postResponse):
                    updatedPostData.onNext(postResponse)
                    commentComplete.onNext(true)
                case .failure(let error):
                    print(error, "✅ PostResponse Error ")
                    commentComplete.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            viewWillAppear:input.viewWillAppear.asDriver(onErrorJustReturn: false),
            commentButtonUI: commentButtonEnable.asDriver(onErrorJustReturn: false),
            postData:postData,
            commentPost: postCommentData,
            updatedPost: updatedPostData,
            commentComplete: commentComplete.asDriver(onErrorJustReturn: false)
        )
    }
}
