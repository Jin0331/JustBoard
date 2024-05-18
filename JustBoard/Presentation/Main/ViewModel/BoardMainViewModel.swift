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
        let dmButtonClicked : ControlEvent<Void>
    }
    
    struct Output {
        let viewWillAppear : Driver<Bool>
        let myChatList : PublishSubject<MyChatResponse>
    }
    
    func transform(input: Input) -> Output {
        
        let myChatList = PublishSubject<MyChatResponse>()
        
        input.dmButtonClicked
            .flatMap { _ in
                return NetworkManager.shared.myChatList()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myChatResponse):
                    myChatList.onNext(myChatResponse)
                case .failure(_):
                    print("error")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            viewWillAppear: input.viewWillAppear.asDriver(onErrorJustReturn: false),
            myChatList: myChatList
        )
    }
}
