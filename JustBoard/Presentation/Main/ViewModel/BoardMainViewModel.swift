//
//  BoardMainViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardMainViewModel : MainViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
    }
    
    struct Output {
        let viewWillAppear : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            viewWillAppear: input.viewWillAppear.asDriver(onErrorJustReturn: false)
        )
    }
}
