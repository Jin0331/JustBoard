//
//  BoardUserViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/2/24.
//

import Foundation
import Alamofire
import RxSwift

final class BoardUserViewModel : MainViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    var userPost : [PostResponse]
    
    init(userPost : [PostResponse]) {
        self.userPost = userPost
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        let userPost = BehaviorSubject<[PostResponse]>(value: userPost)
        
        
        userPost
            .bind(with: self) { owner, postResponse in
                
//                print(postResponse)
            }
            .disposed(by: disposeBag)
        
        
        return Output()
    }
}
