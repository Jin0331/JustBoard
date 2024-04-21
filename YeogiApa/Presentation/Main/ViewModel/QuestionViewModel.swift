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
        // TextView의 size
        let newWidth = textView.bounds.width - 30
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        let resizedImage = image.resizeImage(targetSize: CGSize(width: newWidth, height: newHeight))
        
        // 기존 속성값
        let currentAttributes = textView.typingAttributes
        
        // 이미지를 삽입할 위치 설정 (기존 텍스트 끝에 삽입)
        let endPosition = textView.endOfDocument
        let insertionPoint = textView.offset(from: textView.beginningOfDocument, to: endPosition)
        
        // NSAttributedString을 사용하여 이미지를 NSTextAttachment로 감싸기
        
        let attachment = NSTextAttachment()
        attachment.image = resizedImage
        let imageAttributedString = NSAttributedString(attachment: attachment)
        textView.textStorage.insert(imageAttributedString, at: insertionPoint)
    }
}
