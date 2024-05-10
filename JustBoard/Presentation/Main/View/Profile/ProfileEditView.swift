//
//  ProfileEditView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/9/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ProfileEditView: BaseView {

    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let profileChangeBUtton = UIButton().then {
        $0.setImage(DesignSystem.sfSymbol.camera, for: .normal)
        $0.backgroundColor = DesignSystem.commonColorSet.white
        $0.tintColor = DesignSystem.commonColorSet.lightBlack
    }
    
    lazy var nickname = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요"
        $0.textAlignment = .center
        $0.font = DesignSystem.mainFont.customFontHeavy(size: 22)
        $0.borderStyle = .roundedRect
        $0.layer.borderColor = DesignSystem.commonColorSet.gray.cgColor
        $0.layer.cornerRadius = 10
    }
    
    let editButton = CompleteButton(title: "수정하기", image: nil, fontSize: 18)
    let withdrawButton = CompleteButton(title: "탈퇴하기", image: nil, fontSize: 18).then {
        $0.backgroundColor = DesignSystem.commonColorSet.red
    }
    
    override func configureHierarchy() {
        [profileImage, profileChangeBUtton, nickname, editButton, withdrawButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(50)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        
        profileChangeBUtton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImage)
            make.size.equalTo(22)
        }
        
        nickname.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(70)
            make.horizontalEdges.equalTo(nickname)
            make.height.equalTo(nickname)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(editButton)
            make.height.equalTo(editButton)
        }
    }

}

extension ProfileEditView {
    
    func updateUI(_ data : ProfileResponse) {
        addimage(imageUrl: data.profileImageToUrl)
        nickname.text = data.nick
    }
    
    func updateProfileUI(_ data : UIImage) {
        profileImage.image = data
    }
    
    func addimage(imageUrl : URL) {
        
        KingfisherManager.shared
            .retrieveImage(with: imageUrl, options: [.requestModifier(AuthManager.kingfisherAuth())]) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    profileImage.image = value.image
                    profileImageCircle()
                case .failure(_):
                    print("profile image 없음")
                }
            }
    }
    
    private func profileImageCircle() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        }
    }
}
