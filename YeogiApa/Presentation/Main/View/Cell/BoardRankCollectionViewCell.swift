//
//  BoardRankCollectionViewCell.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/30/24.
//

import UIKit
import Then
import SnapKit
import Reusable
import Kingfisher

final class BoardRankCollectionViewCell : BaseCollectionViewCell, Reusable {
    
    private let rankLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let boardNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    private let countLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
        $0.clipsToBounds = true
        $0.textColor = DesignSystem.commonColorSet.white
        $0.backgroundColor = DesignSystem.commonColorSet.lightBlack
        $0.textAlignment = .center
    }
    
    
    override func configureHierarchy() {
        [rankLabel, profileImage, boardNameLabel, countLabel].forEach { contentView.addSubview($0)}
    }
    
    override func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(rankLabel)
            make.leading.equalToSuperview().inset(45)
            make.size.equalTo(40)
        }
        
        boardNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rankLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
    }
    
    func updateUI(_ itemIdentifier : PostRank) {
        profileImageCircle()
        
        rankLabel.text = String(itemIdentifier.boardRank + 1) + "."
        rankLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 18, weight: .heavy) : .systemFont(ofSize: 18, weight: .regular)
        rankLabel.textColor = itemIdentifier.boardRank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.black
        
        boardNameLabel.text = itemIdentifier.productId
        boardNameLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 18, weight: .heavy) : .systemFont(ofSize: 18, weight: .regular)
        
        countLabel.text = String(itemIdentifier.count)
        countLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 15, weight: .heavy) : .systemFont(ofSize: 15, weight: .regular)
        countLabel.backgroundColor = itemIdentifier.boardRank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.lightBlack
    }
    
    func updateUI(_ itemIdentifier : UserRank) {
        profileImageCircle()
        
        rankLabel.text = String(itemIdentifier.boardRank + 1) + "."
        rankLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 18, weight: .heavy) : .systemFont(ofSize: 18, weight: .regular)
        rankLabel.textColor = itemIdentifier.boardRank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.black
        
        addimage(imageUrl: itemIdentifier.profileImage)
        
        boardNameLabel.text = itemIdentifier.nickName
        boardNameLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 18, weight: .heavy) : .systemFont(ofSize: 18, weight: .regular)
        
        countLabel.text = String(itemIdentifier.count)
        countLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 15, weight: .heavy) : .systemFont(ofSize: 15, weight: .regular)
        countLabel.backgroundColor = itemIdentifier.boardRank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.lightBlack
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = nil
        rankLabel.font = nil
        rankLabel.textColor = DesignSystem.commonColorSet.black
        
//        profileImage.image = nil
        
        boardNameLabel.text = nil
        boardNameLabel.font = nil
        
        countLabel.text = nil
        countLabel.font = nil
        countLabel.backgroundColor = nil
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
