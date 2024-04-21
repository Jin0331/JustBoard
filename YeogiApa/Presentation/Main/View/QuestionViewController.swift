//
//  QuestionViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import UIKit
import YPImagePicker
import RxSwift
import RxCocoa

final class QuestionViewController: RxBaseViewController {
    
    private let mainView = QuestionView()
    lazy var viewModel = QuestionViewModel(textView: mainView.contentsTextView)
    weak var parentCoordinator : QuestionCoordinator?
    private let seletecedImage = PublishSubject<UIImage>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let category = PublishSubject<Category>()
        let link = PublishSubject<URL>()
        
        // image Picker
        mainView.imageAddButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.addImage()
            }
            .disposed(by: disposeBag)
        
        // category Picker
        mainView.categorySelectButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.addCategory() { value in
                    category.onNext(value)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        
        let input = QuestionViewModel.Input(
            titleText: mainView.titleTextField.rx.text.orEmpty,
            contentsText: mainView.contentsTextView.rx.text.orEmpty,
            addedImage: seletecedImage,
            addCategory: category
        )
        
        let output = viewModel.transform(input: input)

    }
    
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.rightBarButtonItem = mainView.searchButtonItem
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
    private func addCategory(completion : @escaping ((Category) -> Void)) {
        let vc = CategorySelectViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.setupSheetPresentationFlexible()
        
        vc.sendData = { [weak self] value in
            guard let self = self else { return }
            mainView.categorySelectButton.setTitle(value.rawValue, for: .normal)
            completion(value)
        }

        present(nav, animated: true)
    }
}

//MARK: - ImagePicker
extension QuestionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            print(pickedImage)
            seletecedImage.onNext(pickedImage)
            mainView.contentsTextViewUIUpdate()
        }
        dismiss(animated: true, completion: nil)
    }
}
