//
//  QuestionViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestionViewController: RxBaseViewController {
    
    private let mainView = QuestionView()
    lazy var viewModel = QuestionViewModel(textView: mainView.contentsTextView)
    weak var parentCoordinator : QuestionCoordinator?
    private let productId : String
    private let seletecedImage = PublishSubject<UIImage>()
    
    init(productId : String) {
        self.productId = productId
    }
    
    override func loadView() {
        view = mainView
    }
    
    
    override func bind() {
        let productId = BehaviorSubject<String>(value: productId)
        let link = BehaviorSubject<String>(value: "")
        
        // image Picker
        mainView.imageAddButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.addImage()
            }
            .disposed(by: disposeBag)
        
        mainView.linkAddButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.addLink() { value in
                    link.onNext(value)
                }
            }
            .disposed(by: disposeBag)
        
        let input = QuestionViewModel.Input(
            titleText: mainView.titleTextField.rx.text.orEmpty,
            contentsText: mainView.contentsTextView.rx.text.orEmpty,
            addedImage: seletecedImage,
            addProductId: productId,
            addLink: link,
            completeButtonTap: mainView.completeButtonItem.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.overAddedImageCount
            .drive(with: self) { owner, validImageAdd in
                
                if validImageAdd {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // in half a second...
                        owner.showAlert(title: "이미지 개수 초과", text: "이미지는 5개 이하로 추가해주세요 🥲", addButtonText: "확인")
                    }
                }
            }
            .disposed(by: disposeBag)

        
        output.writeButtonUI
            .drive(with: self) { owner, valid in
                owner.navigationItem.rightBarButtonItem = valid ? UIBarButtonItem(customView: owner.mainView.completeButtonItem) : nil
            }
            .disposed(by: disposeBag)
        
        output.writeComplete
            .drive(with: self) { owner, complete in
                //TODO: - Coordinator 종료 및 Board로 이동
                owner.parentCoordinator?.toBaord()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationItem.title = productId + " 게시판"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: DesignSystem.commonColorSet.black
        ]
    }
    
    override func configureView() {
        super.configureView()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainView.titleTextField.alignTextVerticallyInContainer()
    }
    
    deinit {
        print(#function, "QuestionViewController 🔆")
    }
}


//MARK: - Present (PopUpview) -> Coordinator로 하는 건 좀 힘든듯?
extension QuestionViewController {
    
    private func addLink(completion : @escaping ((String) -> Void)) {
        let vc = LinkViewController()
        vc.setupSheetPresentationFlexible(height: 200)
        
        vc.sendData = { value in
            completion(value)
        }

        present(vc, animated: true)
    }
}

//MARK: - ImagePicker
extension QuestionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            seletecedImage.onNext(pickedImage)
            mainView.contentsTextViewUIUpdate()
        }
        dismiss(animated: true, completion: nil)
    }
}
