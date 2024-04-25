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
    }
    
    func transform(input: Input) -> Output {
        
        let commentButtonEnable = BehaviorSubject<Bool>(value: false)
        
        input.commentText
            .bind(with: self) { owner, text in
                commentButtonEnable.onNext(!text.isEmpty)
            }
            .disposed(by: disposeBag)
        
        input.commentComplete
            .bind(with: self) { owner, _ in
                print("HI")
            }
            .disposed(by: disposeBag)
        
        return Output(
            viewWillAppear:input.viewWillAppear.asDriver(onErrorJustReturn: false),
            commentButtonUI: commentButtonEnable.asDriver(onErrorJustReturn: false),
            postData:postData
        )
    }
}
