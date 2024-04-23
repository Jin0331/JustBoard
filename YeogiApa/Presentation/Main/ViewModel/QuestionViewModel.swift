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
        let contentsText : ControlProperty<String> // content1
        let addedImage : Observable<UIImage> // files
        let addCategory : Observable<Category> // content2
        let addLink : BehaviorSubject<String> // content3
        let completeButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let overAddedImageCount : Driver<Bool>
        //        let writeComplete : Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validTitle = PublishSubject<Bool>()
        let validContents = PublishSubject<Bool>()
        let overAddedImageCount = PublishSubject<Bool>()
        let uploadedFiles = PublishSubject<[String]>()
        let uploadedFilesLocation = PublishSubject<String>()
        
        // title
        input.titleText
            .bind(with: self) { owner, title in
                !title.isEmpty ? validTitle.onNext(true) : validTitle.onNext(false)
            }
            .disposed(by: disposeBag)
        
        
        // 이미지 추가
        input.addedImage
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, image in
                
                // 이미지 압축
                let resizedImage = Double(image.pngData()!.count) > ImageResize.maxSize.rawValue ? image.compressImage(to: ImageResize.compressSize.rawValue)! : image
                
                // 이미지 개수 검사
                if Double(owner.textView.getNumberOfImages()) > ImageResize.maxCount.rawValue { // image max count
                    overAddedImageCount.onNext(true)
                } else {
                    owner.insertImageIntoTextView(image: resizedImage)
                    overAddedImageCount.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        // main textView 추적
        input.contentsText
            .bind(with: self) { owner, text in
                
                !text.isEmpty ? validContents.onNext(false) : validContents.onNext(true)
            }
            .disposed(by: disposeBag)
        
        input.completeButtonTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
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
                    uploadedFilesLocation.onNext(owner.textView.getImageLocations()
                        .map { String($0) }.joined(separator: " ")) // 이미지 위치
//                    print("이미지 개수 :",owner.textView.getNumberOfImages(), "이미지 위치:", owner.textView.getImageLocations(), "이미지 주소 : ", owner.textView.getImageURLs())
                case .failure(let error): // 이미지 없음
                    uploadedFiles.onNext([])
                }
            }
            .disposed(by: disposeBag)
        
        // Post 작성
        let writeRequest = Observable.combineLatest(input.addCategory, input.titleText, input.contentsText, input.addLink, uploadedFilesLocation, uploadedFiles)
            .map { category, title, contents, link, position, files in
                return WriteRequest(product_id: category.rawValue, title: title, content1: contents, content2: link, content3: position, files: files)
            }
            .flatMap { writeRequest in
                NetworkManager.shared.post(query: writeRequest)
            }
        
        writeRequest
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let writeResponse):
                    
                    print(writeResponse)
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            overAddedImageCount:overAddedImageCount.asDriver(onErrorJustReturn: false)
            )
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
