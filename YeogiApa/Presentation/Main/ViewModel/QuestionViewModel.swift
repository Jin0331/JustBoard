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
        let contentsText : ControlProperty<String>
        let addedImage : Observable<UIImage>
//        let completeButtonTap : ControlEvent<Void>
    }
    
    struct Output {
//        let writeComplete : Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validTitle = PublishSubject<String>()
        
        input.addedImage
            .bind(with: self) { owner, image in
                owner.insertImageIntoTextView(image: image)
            }
            .disposed(by: disposeBag)
        
        
        input.contentsText
            .bind(with: self) { owner, text in
                print(text)
            }
            .disposed(by: disposeBag)
        
        
        return Output()
    }
    
    
    private func insertImageIntoTextView(image: UIImage) {
        // 이미지를 삽입할 위치 설정 (기존 텍스트 끝에 삽입)
        let endPosition = textView.endOfDocument
        let insertionPoint = textView.offset(from: textView.beginningOfDocument, to: endPosition)
        
        // NSAttributedString을 사용하여 이미지를 NSTextAttachment로 감싸기
        let attachment = NSTextAttachment()
        attachment.image = image
        let imageAttributedString = NSAttributedString(attachment: attachment)
        
        // 이미지를 삽입할 위치에 NSAttributedString 삽입
        let mutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableAttributedString.insert(imageAttributedString, at: insertionPoint)
        textView.attributedText = mutableAttributedString
    }
}
