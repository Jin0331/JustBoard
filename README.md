# 🤯 **자게 - 자유게시판**

![merge1](https://github.com/Jin0331/JustBoard/assets/42958809/151b8a43-457e-4128-9267-b8ccef7b2fa1)

![merge2](https://github.com/Jin0331/JustBoard/assets/42958809/01855e5f-714d-4396-9c9f-a88c266918a6)


> 출시 기간 : 2024.04.11 - 05.05 (약 3주)
>
> 기획/디자인/개발 1인 개발
>
> 프로젝트 환경 - iPhone 전용(iOS 16.0+), 라이트 모드 고정

---

<br>

## 🔆 **한줄소개**

***자게?, 아니 자게! - 자유로운 소통을 위한 자유게시판***

<br>

## 🔆 **핵심 기능**

* **회원 가입 / 회원탈퇴 / 로그인 / 로그아웃** 

* **게시글 / 댓글 / 공감 및 비공감 작성 및 조회**  

* **프로필 조회 / 팔로잉 팔로우**

* **실시간 유저 / 게시글 순위 조회**

* **실시간 1:1 채팅**

<br>

## 🔆 **적용 기술**

* ***프레임워크***

    UIKit, SwiftUI

* ***아키텍처***

    MVVM-C

* ***오픈 소스***(Cocoapods)

  RxSwift / RxDataSources / Combine / Realm

  SocketIO / Alamofire / Kinfisher

  Snapkit / Then / Tabman / SideMenu
  
<br>

## 🔆 **적용 기술 소개**
## 🔆 프로젝트 수행 중 심각하게 고민한 부분

### 1. NSTextAttachment를 활용한 UITextView 내의 UIImage 추가 (feat. Location)

❌ **문제 상황**

>1. UIImage를 별도의 항목으로 추가하는 것이 아닌, UITextView내의 Text(String)로 추가하는 것을 목표로 구현을 시도
>2. UIImage를 TextView에 추가하는 것은 가능했지만, 1) 기존 Text가 존재하거나, 2) UIImage 추가 후 Text 또는 UIImage를 추가하는 경우 순서가 보장되지 않는 문제가 발생

🔆 **해결 방법**

1. `func insertImageIntoTextView`를 통한 UITextView에 특정 UIImage 삽입

   ```swift
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
   ```

2. `func getImageLocations`를 통한 UITextView에 삽입된 특정 UIImage의 position 추출

   ```swift
   func getImageLocations() -> [Int] {
       var imageLocations: [Int] = []
       self.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: self.attributedText.length), options: []) { (value, range, stop) in
           if let _ = value as? NSTextAttachment {
               imageLocations.append(range.location)
           }
       }
       return imageLocations
   }
   ```

3. `func _addTextViewImage` 를 통하여 Text가 순서가 보장되며 이미지를 추가함

   ```swift
   private func _addTextViewImage(url : URL, location: Int) {
   
       KingfisherManager.shared.downloader.downloadImage(with: url, options: [.requestModifier(AuthManager.kingfisherAuth())] ) { [weak self] result in
   
           guard let self = self else { return }
           switch result {
           case .success(let imageResult):
               // 이미지 다운로드 성공 시 NSAttributedString을 만들어서 UITextView에 삽입
               let newWidth = textView.bounds.width - 15
               let scale = newWidth / imageResult.image.size.width
               let newHeight = imageResult.image.size.height * scale
               let resizedImage = imageResult.image.resizeImage(targetSize: CGSize(width: newWidth, height: newHeight))
   
               let attachment = NSTextAttachment()
               attachment.image = resizedImage
               let imageAttributedString = NSAttributedString(attachment: attachment)
   
               // 원하는 위치에 이미지 삽입
               let mutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
               let range = NSRange(location: location, length: 0) // 특정 위치 (예: 10번째 문자 뒤)
               mutableAttributedString.insert(imageAttributedString, at: range.location)
               textView.attributedText = mutableAttributedString
               textViewDidChange(textView)
   
           case .failure(let error):
               print("Image download failed: \(error)")
   
           }
       }
   }
   ```
![0505230943639534](https://github.com/Jin0331/YeogiApa/assets/42958809/2c43064d-8fa3-4dcb-a232-d0c78d23126a)

<br>

### 2. 앱의 화면전환 관리와 전체적인 구조화를 위한 Coordinator 패턴 적용

❌ **문제 상황**

>1. 게시판 기능이 주된 프로젝트로, 구성된 View의 재활용 및 빈번한 화면전환이 발생함
>2. 기존 화면전환 방식은 ViewController 내에서 다른 ViewController를 호출하는 형태로 쉽게 코드로 구현이 가능하지만, 앱의 구조가 복잡해짐에 따라 화면전환을 관리하는 데 애로가 발생하였음

🔆 **해결 방법**

1. Protocol 채택을 통한 Coordinator 패턴 적용

   ```swift
   protocol Coordinator : AnyObject {
       var childCoordinators: [Coordinator] { get set }
       var navigationController: UINavigationController { get set }
       
       func start()
   }
   ```

2. Coordnaitor 구성도
![coordinator조성도](https://github.com/Jin0331/YeogiApa/assets/42958809/23671dbc-3d77-4521-9175-c78438c06805)

