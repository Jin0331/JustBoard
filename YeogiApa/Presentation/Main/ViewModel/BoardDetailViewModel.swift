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
    let updatedPostData : BehaviorSubject<PostResponse>
    var disposeBag: DisposeBag = DisposeBag()
    
    init(_ receiveData: PostResponse) {
        self.postData = BehaviorSubject<PostResponse>(value: receiveData)
        self.updatedPostData = BehaviorSubject<PostResponse>(value: receiveData)
    }
    
    struct Input {
        let likeButton: ControlEvent<Void>
        let commentText : ControlProperty<String>
        let commentComplete : ControlEvent<Void>
    }
    
    struct Output {
        let commentButtonUI : Driver<Bool>
        let postData : BehaviorSubject<PostResponse>
        let commentPost : PublishSubject<Comment>
        let updatedPost : BehaviorSubject<PostResponse>
        let commentComplete : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let likeButtonEnable = PublishSubject<Void>()
        
        let commentButtonEnable = BehaviorSubject<Bool>(value: false)
        let commentRequestModel = PublishSubject<CommentRequest>()
        let postCommentData = PublishSubject<Comment>()
        let commentComplete = PublishSubject<Bool>()
        
        
        //MARK: - like
        input.likeButton
            .withLatestFrom(updatedPostData)
            .map {
                let myLike = $0.likes.contains(UserDefaultManager.shared.userId!) ? true : false
                return (myLike, $0.postID)
            }
            .flatMap { value in
                let toggleLike = !value.0
                return NetworkManager.shared.likes(query: LikesRequest(like_status: toggleLike), postId: value.1)
            }
            .bind(with: self) { owner, data in
                switch data {
                case .success(let likestResponse):
                    print(likestResponse, "✅ LikesResponse")
                    likeButtonEnable.onNext(())
                case .failure(let error):
                    print(error, "✅ LikesResponse Error")
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(likeButtonEnable, postData)
            .map { $0.1.postID }
            .flatMap {
                NetworkManager.shared.post(postId: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let postResponse):
                    print(postResponse)
                    owner.updatedPostData.onNext(postResponse)
                case .failure(let error):
                    print(error, "✅ PostResponse Error ")
                }
            }
            .disposed(by: disposeBag)
        
        //MARK: - Comment 관련
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
                    owner.updatedPostData.onNext(postResponse)
                    commentComplete.onNext(true)
                case .failure(let error):
                    print(error, "✅ PostResponse Error ")
                    commentComplete.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            commentButtonUI: commentButtonEnable.asDriver(onErrorJustReturn: false),
            postData:postData,
            commentPost: postCommentData,
            updatedPost: updatedPostData,
            commentComplete: commentComplete.asDriver(onErrorJustReturn: false)
        )
    }
}
