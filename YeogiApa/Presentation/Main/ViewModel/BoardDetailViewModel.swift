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
    }
    
    struct Output {
        let viewWillAppear : Driver<Bool>
        let postData : BehaviorSubject<PostResponse>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            viewWillAppear:input.viewWillAppear.asDriver(onErrorJustReturn: false),
            postData:postData
        )
    }
}
