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
        
        let completeButton = PublishSubject<Void>()
        
        baseView.editButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert2(title: "프로필 수정", text: "프로필을 수정하시곘습니까?", addButtonText1: "네", addButtonText2: "아니요") {
                    completeButton.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
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
            completeButton: completeButton
            
        )
        
        let output = viewModel.transform(input: input)
        
        output.currentProfileResponse
            .bind(with: self) { owner, profileResponse in
                owner.tabBarController?.tabBar.isHidden = true
                owner.baseView.updateUI(profileResponse)
                owner.seletecedImage.onNext((owner.baseView.profileImage.image?.jpegData(compressionQuality: 0.8))!)
            }
            .disposed(by: disposeBag)
        
        output.editComplete
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
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
        
        let defaultAction = UIAlertAction(title: "기본이미지", style: .default) { [weak self] (action) in
            guard let self else { return }
            
            let group = DispatchGroup()
            
            group.enter()
            DispatchQueue.main.async(group: group) { [weak self] in
                guard let self = self else { return }
                baseView.addimage(imageUrl: DesignSystem.defaultimage.defaultProfileWithURl)
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else { return }
                
                if let image = baseView.profileImage.image {
                    seletecedImage.onNext(image.jpegData(compressionQuality: 0.8)!)
                } else {
                    print("뭐냐")
                }
            }
        }
        
        let pickerAction = UIAlertAction(title: "앨범", style: .default) { [weak self] (action) in
            guard let self else { return }
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
    
            present(imagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        showAlert(title: "이미지 선택하기", message: nil, preferredStyle: .actionSheet, actions: [defaultAction, pickerAction, cancelAction])
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            seletecedImage.onNext(pickedImage.jpegData(compressionQuality: 0.8)!)
            baseView.updateProfileUI(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
