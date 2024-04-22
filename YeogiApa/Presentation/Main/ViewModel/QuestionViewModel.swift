//
//  QuestionViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import STTextView // anti pattern... 어쩔 수 없다 흑흑;;;

final class QuestionViewModel : MainViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    var textView : STTextView

    init(textView: STTextView) {
        self.textView = textView
    }
    
    struct Input {
        let titleText : ControlProperty<String>
        let contentsText : ControlProperty<String>
        let addedImage : Observable<UIImage>
        let addCategory : Observable<Category>
        let addLink : Observable<String>
        let completeButtonTap : ControlEvent<Void>
    }
    
    struct Output {
//        let writeComplete : Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validTitle = PublishSubject<String>()
        
        //TODO: - image 개수 추적
        
        input.addedImage
            .bind(with: self) { owner, image in
                owner.insertImageIntoTextView(image: image)
            }
            .disposed(by: disposeBag)
        
        
        input.contentsText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                print(text, "이미지 개수 :",owner.textView.getNumberOfImages(), "이미지 위치:", owner.textView.getImageLocations(), "이미지 주소 : ", owner.textView.getImageURLs())
            }
            .disposed(by: disposeBag)
        
        input.completeButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { [weak self] _ in
                guard let self = self else { print("여기는 아니겠지?");return FilesRequest(files: []) }
                return FilesRequest(files: textView.getImageURLs())
            }
            .flatMap { filesRquest in
                NetworkManager.shared.post(query: filesRquest)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let filesResponse):
                    print(filesResponse.files, "✅ 이미지 업로드 성공")
                case .failure(let error):
                    print(error)
                }
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
        
        // 이미지를 삽입할 위치 설정 (기존 텍스트 끝에 삽입)
        let endPosition = textView.endOfDocument
        let insertionPoint = textView.offset(from: textView.beginningOfDocument, to: endPosition)
        
        let attachment = NSTextAttachment()
        attachment.image = resizedImage
        let imageAttributedString = NSAttributedString(attachment: attachment)
        textView.textStorage.insert(imageAttributedString, at: insertionPoint)
    }
}
