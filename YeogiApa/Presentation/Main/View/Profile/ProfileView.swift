//
//  ProfileView.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class ProfileView: BaseView {

    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .red
    }
    
    let author = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = DesignSystem.commonColorSet.gray
        $0.backgroundColor = .yellow
    }
    
    override func configureHierarchy() {
        [profileImage, author].forEach { addSubview($0)}
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.size.equalTo(80)
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
    }
}

extension ProfileView {
    
    func updateUI() {
        
    }
    
    private func addimage(imageUrl : URL) {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        profileImage.addSubview(indicator)
        
        KingfisherManager.shared
            .retrieveImage(with: imageUrl, options: [.requestModifier(AuthManager.kingfisherAuth())]) { [weak self] result in
                guard let self = self else { return }
                
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                
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
