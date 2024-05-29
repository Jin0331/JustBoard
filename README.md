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

## 🤯 **한줄소개**

***자게?, 아니 자게! - 자유로운 소통을 위한 자유게시판***

<br>

## 🤯 **핵심 기능**

* **회원가입 / 회원탈퇴 / 로그인 / 로그아웃** 

* **게시글 / 댓글 / 공감 및 비공감 작성 및 조회**  

* **프로필 수정 및 조회 / 팔로잉 팔로우**

* **실시간 유저 / 게시판의 게시글 순위 조회**

* **실시간 1:1 채팅**

<br>

## 🤯 **적용 기술**

* ***프레임워크***

    UIKit, SwiftUI

* ***아키텍처***

    MVVM-C

* ***오픈 소스***(Cocoapods)

  RxSwift / Combine / Realm

  Alamofire / Kinfisher / SocketIO

  RxDataSource / Diffable DataSource / Snapkit / Tabman / SideMenu

<br>

## 🤯 **적용 기술 소개**

***MVVM-C***

* View 및 Business 로직을 분리하기 위한 `MVVM-C` 아키텍처를 도입

* `Input-Output 패턴`의 Protocol을 채택함으로써 User Interaction과 View Data 핸들링

    ```swift
    protocol ViewModelType {
        var disposeBag : DisposeBag { get }
        associatedtype Input
        associatedtype Output
        func transform(input : Input) -> Output
    }

    protocol CombineViewModelType : AnyObject, ObservableObject {
        associatedtype Input
        associatedtype Output
        
        var cancellables : Set<AnyCancellable> {get set}
        
        var input : Input {get set}
        var output : Output {get set}
        
        func transform()
    }
    ```

* Flow Logic을 관리하고, View 간의 Dependency를 줄이기 위해 `Coordinator 패턴` 적용

    ```swift
    protocol Coordinator : AnyObject {
        var finishDelegate: CoordinatorFinishDelegate? { get set }
        var childCoordinators: [Coordinator] { get set }
        var navigationController: UINavigationController { get set }
        var type: CoordinatorType { get }
        
        func start()
        func finish()
    }
    
    extension Coordinator {

    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
    ```
    <br>

    ![coordinator조성도](https://github.com/Jin0331/YeogiApa/assets/42958809/23671dbc-3d77-4521-9175-c78438c06805)

***Reactive Programming***

* 비동기 Event의 관리를 위한 `RxSwift`와 `Combine`를 이용한 Reactive Programming 구현


***Alamofire***

* `URLRequestConvertible`을 활용한 `Router 패턴` 기반의 네트워크 통신 추상화

* `RequestInterceptor Protocol` 채택함으로써, `JWT(Json Web Token)` 갱신 적용

***SocketIO + Realm***

* Singleton 패턴 기반의 양방향 통신 적용

* 과도한 API 호출을 방지하기 위해, `Realm Table Fetch -> Latest Date를 Server에 요청 -> Realm Table Update -> Connect Socket`의 Logic을 이용하여 사용자간 1:1 채팅 구현

## 🤯 트러블슈팅

### 1. UITextView 내의 순서가 보장된 UIImage 추가

* **문제 상황**

    >1. UIImage를 별도의 항목으로 추가하는 것이 아닌, UITextView내의 Text(String)로 추가하는 것을 목표로 구현을 시도
    >2. UIImage를 TextView에 추가하는 것은 가능했지만, 1) 기존 Text가 존재하거나, 2) UIImage 추가 후 Text 또는 UIImage를 추가하는 경우 순서가 보장되지 않는 문제가 발생

<br>

* **해결 방법**

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
        
        <p align="center">
            <img src="https://github.com/Jin0331/JustBoard/assets/42958809/8ca30896-6bf3-425a-8036-ea154c6fab1a" width="30%" height="30%"/>
        </p>
        <br>

### 2. UIKit과 SwiftUI의 Navigation Stack의 중첩 

* **문제 상황**

    > 1. UIKit 프로젝트에서 UIHostringController를 사용하여 SwiftUI의 View를 적용시키고자 하였으며, 복수의 View로 구성되어 Navigation을 이용한 화면 전환이 필요하게 되었음.
    > 2. 하지만 Coordinator 패턴의 채택으로 모든 화면 전환은 Coordinator가 관장하는데, SwiftUI View에서 Navigation Stack을 사용하여 화면 전환을 시도할 경우, UIKit의 UINavigationController와 SwiftUI의 Navigation Stack이 충돌되는 현상 발생
    
    <br>

    <p align="center">
        <img src="https://github.com/Jin0331/JustBoard/assets/42958809/aa2a0471-e39b-4ac4-b2a9-06ddf0bcd52c" width="30%" height="30%"/>
    </p>

    <br>

* **해결 방법**

    1. SwiftUI의 Navigation Stack을 이용한 화면의 직접 전환이 아닌, UIKit의 Coordinator에 의존하여 화면 전환을 하도록 구성
    
    ```swift
    final class ChatListCoordinator : Coordinator {
        weak var finishDelegate: CoordinatorFinishDelegate?
        var childCoordinators: [Coordinator] = []
        var navigationController: UINavigationController
        var parentBoardCoordinator : BoardMainCoordinator?
        var type: CoordinatorType { .tab }
        
        init(navigationController: UINavigationController) {
            self.navigationController = navigationController
        }
        
        func start() { }
        
        func start(chatlist : MyChatResponse) {
            
            var childView = ChatListView(chatList: chatlist)
            childView.parentCoordinator = self
            let vc = ChatListViewController(contentViewController: UIHostingController(rootView: childView))
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    ```

    2. Coordinator를 통해 SwiftUI의 View를 직접 호출하는 것이 아닌, 해당 SwiftUI View의 UIHostringController를 호출함으로써 UIKit과 SwiftUI의 Navigation Stack 중첩 문제를 해결

    <p align="center">
        <img src="https://github.com/Jin0331/JustBoard/assets/42958809/c1146361-c355-4775-a620-ac8a510717f7" width="30%" height="30%"/>
    </p>
