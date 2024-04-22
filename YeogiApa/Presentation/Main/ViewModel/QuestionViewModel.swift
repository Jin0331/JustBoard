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
        let overAddedImageCount : Driver<Bool>
//        let writeComplete : Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validTitle = PublishSubject<String>()
        let overAddedImageCount = PublishSubject<Bool>()
        let uploadedFiles = PublishSubject<[String]>()
        let uploadedFilesLocation = PublishSubject<[Int]>()
        
        input.addedImage
            .bind(with: self) { owner, image in
                                if owner.textView.getNumberOfImages() < 5 { // image max count
                    owner.insertImageIntoTextView(image: image)
                    overAddedImageCount.onNext(false)
                } else {
                    print("?????")
                    overAddedImageCount.onNext(true)
                }

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
                NetworkManager.shared.post(query: filesRquest, category: "test")
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let filesResponse):
                    print(filesResponse.files, "✅ 이미지 업로드 성공")
                    uploadedFiles.onNext(filesResponse.files)
                    uploadedFilesLocation.onNext(owner.textView.getImageLocations()) // 이미지 위치
                case .failure(let error): // 이미지 없음
//                    print(error, "❗️ 이미지 없음")
                    uploadedFiles.onNext([])
                }
            }
            .disposed(by: disposeBag)
        
        // Post 작성
        
        
        
//        uploadedFiles
//            .bind(with: self) { owner, files in
//                print(files)
//            }
//            .disposed(by: disposeBag)
        
        
        return Output(overAddedImageCount:overAddedImageCount.asDriver(onErrorJustReturn: false))
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
