//
//  BoardMainViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardMainViewModel : MainViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let questionButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let questionButtonTap : Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        
        return Output(questionButtonTap: input.questionButtonTap.asDriver())
    }
}
