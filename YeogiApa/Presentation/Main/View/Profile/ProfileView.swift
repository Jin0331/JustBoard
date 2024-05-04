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
import RxDataSources
import Reusable
import Tabman
import Pageboy

final class ProfileView: BaseView {

    let me : Bool
    let tabmanViewController : TabmanViewController
    
    init(tabmanViewController: TabmanViewController, me: Bool) {
        self.tabmanViewController = tabmanViewController
        self.me = me
        super.init(frame: .zero)
    }
    
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let author = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    let profileEditButton = CompleteButton(title: "프로필 수정", image: nil, fontSize: 16, disable: false)
    
    let followButton = CompleteButton(title: "팔로우", image: nil, fontSize: 16, disable: false)
    
    override func configureHierarchy() {
        [profileImage, author, profileEditButton, followButton, tabmanViewController.view].forEach { addSubview($0)}
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(85)
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        
        if me {
            profileEditButton.snp.makeConstraints { make in
                make.bottom.equalTo(profileImage)
                make.leading.equalTo(profileImage.snp.trailing).offset(10)
                make.height.equalTo(40)
                make.width.equalTo(90)
            }
            
        } else {
            followButton.snp.makeConstraints { make in
                make.bottom.equalTo(profileImage)
                make.leading.equalTo(profileImage.snp.trailing).offset(10)
                make.height.equalTo(40)
                make.width.equalTo(90)
            }
        }
        
        tabmanViewController.view.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
    }
}

extension ProfileView {
    
    func updateUI(_ data : ProfileResponse) {
        addimage(imageUrl: data.profileImageToUrl)
        author.text = data.nick
    }
    
    func updateFollowButton(_ data : Bool) {
        if data {
            followButton.setTitle("팔로잉", for: .normal)
            followButton.backgroundColor = DesignSystem.commonColorSet.black
        } else {
            followButton.setTitle("팔로우", for: .normal)
            followButton.backgroundColor = .systemBlue
        }
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
