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
    let seletecedImage = PublishSubject<UIImage>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        // image Picker
        mainView.imageAddButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.addImage()
            }
            .disposed(by: disposeBag)
        
        
        let input = QuestionViewModel.Input(contentsText: mainView.contentsTextView.rx.text.orEmpty,
                                            addedImage: seletecedImage
                                            
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


// image Picker
extension QuestionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            print(pickedImage)
            seletecedImage.onNext(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
