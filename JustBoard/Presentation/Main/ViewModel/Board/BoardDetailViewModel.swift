//
//  BoardDetailViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 4/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardDetailViewModel : MainViewModelType {
    
    private let postData : BehaviorSubject<PostResponse>
    private let userID : BehaviorSubject<String>
    private let updatedPostData : BehaviorSubject<PostResponse>
    var disposeBag: DisposeBag = DisposeBag()
    
    init(_ receiveData: PostResponse) {
        self.postData = BehaviorSubject<PostResponse>(value: receiveData)
        self.updatedPostData = BehaviorSubject<PostResponse>(value: receiveData)
        self.userID = BehaviorSubject<String>(value: receiveData.creator.userID)
    }
    
    struct Input {
        let profileButton : ControlEvent<Void>
        let likeButton: ControlEvent<Void>
        let unlikeButton: ControlEvent<Void>
        let commentText : ControlProperty<String>
        let commentComplete : ControlEvent<Void>
    }
    
    struct Output {
        let profileType : PublishSubject<(userID:String, me:Bool)>
        let commentButtonUI : Driver<Bool>
        let postData : BehaviorSubject<PostResponse>
        let commentPost : PublishSubject<Comment>
        let updatedPost : BehaviorSubject<PostResponse>
        let commentComplete : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let profileType = PublishSubject<(userID:String, me:Bool)>()
        let likeButtonEnable = PublishSubject<Void>()
        let unlikeButtonEnable = PublishSubject<Void>()
        let commentButtonEnable = BehaviorSubject<Bool>(value: false)
        let commentRequestModel = PublishSubject<CommentRequest>()
        let postCommentData = PublishSubject<Comment>()
        let commentComplete = PublishSubject<Bool>()

        //MARK: - Profile
        input.profileButton
            .withLatestFrom(userID)
            .bind(with: self) { owner, userID in
                let me = UserDefaultManager.shared.userId == userID
                profileType.onNext((userID, me))
            }
            .disposed(by: disposeBag)
        
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
                case .success(_):
                    likeButtonEnable.onNext(())
                case .failure(let error):
                    print(error, "✅ LikesResponse Error")
                }
            }
            .disposed(by: disposeBag)
        
        //MARK: - unlike
        input.unlikeButton
            .withLatestFrom(updatedPostData)
            .map {
                let myUnlike = $0.likes2.contains(UserDefaultManager.shared.userId!) ? true : false
                return (myUnlike, $0.postID)
            }
            .flatMap { value in
                let toggleLike = !value.0
                return NetworkManager.shared.unlikes(query: LikesRequest(like_status: toggleLike), postId: value.1)
            }
            .bind(with: self) { owner, data in
                switch data {
                case .success(_):
                    unlikeButtonEnable.onNext(())
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
                    owner.updatedPostData.onNext(postResponse)
                    NotificationCenter.default.post(name: .boardRefresh, object: nil)
                case .failure(let error):
                    print(error, "✅ PostResponse Error ")
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(unlikeButtonEnable, postData)
            .map { $0.1.postID }
            .flatMap {
                NetworkManager.shared.post(postId: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let postResponse):
                    owner.updatedPostData.onNext(postResponse)
                    NotificationCenter.default.post(name: .boardRefresh, object: nil)
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
                    NotificationCenter.default.post(name: .boardRefresh, object: nil)
                case .failure(let error):
                    print(error, "✅ PostResponse Error ")
                    commentComplete.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        //TODO: - Follow 눌렀을 때 Post 업데이트 필요함
        NotificationCenter.default.rx.notification(.boardRefresh)
            .withLatestFrom(updatedPostData)
            .map { $0.postID }
            .flatMap {
                NetworkManager.shared.post(postId: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let postResponse):
                    owner.updatedPostData.onNext(postResponse)
                case .failure(let error):
                    print(error, "✅ PostResponse Error ")
                }
            }
            .disposed(by: disposeBag)

        return Output(
            profileType:profileType,
            commentButtonUI: commentButtonEnable.asDriver(onErrorJustReturn: false),
            postData:postData,
            commentPost: postCommentData,
            updatedPost: updatedPostData,
            commentComplete: commentComplete.asDriver(onErrorJustReturn: false)
        )
    }
}
