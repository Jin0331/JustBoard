//
//  FollowCollectionViewCell.swift
//  JustBoard
//
//  Created by JinwooLee on 5/5/24.
//

import UIKit
import Then
import SnapKit
import Reusable
import Kingfisher

final class FollowCollectionViewCell: BaseCollectionViewCell, Reusable {
    
    var profileButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let author = UILabel().then {
        $0.font = DesignSystem.mainFont.customFontBold(size: 19)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    let followButton = CompleteButton(title: "팔로우", image: nil, fontSize: 16, disable: false)
    
    override func configureHierarchy() {
        [profileButton, profileImage, author, followButton].forEach { contentView.addSubview($0)}
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(50)
        }
        
        profileButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImage)
        }
        
        author.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(90)
        }
    }
    
    func updateUI(_ itemIdentifier: ProfileResponse) {
        addimage(imageUrl: itemIdentifier.profileImageToUrl)
        author.text = itemIdentifier.nick
    }
    
    func updateFollowButton(_ data : Bool, _ me : Bool) {
        
        if me {
            followButton.isHidden = true
        } else {
            if data {
                followButton.setTitle("팔로잉", for: .normal)
                followButton.backgroundColor = DesignSystem.commonColorSet.black
            } else {
                followButton.setTitle("팔로우", for: .normal)
                followButton.backgroundColor = .systemBlue
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil

        author.text = nil
        author.font = nil
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
