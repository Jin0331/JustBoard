//
//  ProfileEditViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

final class ProfileEditViewController: RxBaseViewController {
    
    private let baseView = ProfileEditView()
    private let viewModel : ProfileEditViewModel
    private var seletecedImage : BehaviorSubject<Data>
    var parentCoordinator : ProfileCoordinator?
    
    init(meProfileResponse: ProfileResponse) {
        self.viewModel = ProfileEditViewModel(profileResponse: BehaviorSubject(value: meProfileResponse))
        self.seletecedImage = BehaviorSubject<Data>(value: Data())
    }
    
    override func loadView() {
        view = baseView
    }

    override func bind() {
        // image Picker
        baseView.profileChangeBUtton.rx.tap
            .bind(with: self) { owner, _ in
                owner.addImage()
            }
            .disposed(by: disposeBag)
        
        let input = ProfileEditViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            addedImage: seletecedImage,
            nickname: baseView.nickname.rx.text.orEmpty,
            completeButton: baseView.editButton.rx.tap
            
        )
        
        let output = viewModel.transform(input: input)
        
        output.currentProfileResponse
            .bind(with: self) { owner, profileResponse in
                owner.tabBarController?.tabBar.isHidden = true
                owner.baseView.updateUI(profileResponse)
                owner.seletecedImage.onNext((owner.baseView.profileImage.image?.jpegData(compressionQuality: 0.8))!)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationItem.title = "프로필 수정"
    }
}

//MARK: - ImagePicker
extension ProfileEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            print(pickedImage)
            seletecedImage.onNext(pickedImage.jpegData(compressionQuality: 0.8)!)
            baseView.updateProfileUI(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
