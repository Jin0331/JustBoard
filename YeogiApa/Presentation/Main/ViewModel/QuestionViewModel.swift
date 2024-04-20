//
//  QuestionViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import STTextView // anti pattern... 어쩔수 없다 흑흑;;;

final class QuestionViewModel : MainViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    var textView : STTextView

    init(textView: STTextView) {
        self.textView = textView
    }
    
    struct Input {
        let completeButtonTap : ControlEvent<Void>
        let contentsText : ControlProperty<String>
    }
    
    struct Output {
        let writeComplete : Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validTitle = PublishSubject<String>()
        
        // title - 유효성 검사
        input.contentsText
            .bind(with: self) { owner, text in
                print(text)
                owner.updateInsertionPoint()
            }
            .disposed(by: disposeBag)
        
        return Output(writeComplete: input.completeButtonTap.asDriver())
    }
    
    private func updateInsertionPoint() {
        let endPosition = textView.endOfDocument
        let insertionPoint = textView.offset(from: textView.beginningOfDocument, to: endPosition)
        print("Insertion Point: \(insertionPoint)")
    }
}
