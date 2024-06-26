//
//  BoardRankCollectionViewCell.swift
//  JustBoard
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
        $0.font = DesignSystem.mainFont.customFontBold(size: 18)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let boardNameLabel = UILabel().then {
        $0.font = DesignSystem.mainFont.customFontMedium(size: 18)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    private let countLabel = UILabel().then {
        $0.font = DesignSystem.mainFont.customFontBold(size: 15)
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
    
    func updateUI(_ itemIdentifier: PostRank) {
        profileImageCircle()
        updateUICommon(rank: itemIdentifier.boardRank, name: itemIdentifier.productId, count: itemIdentifier.count, isPost: true)
    }

    func updateUI(_ itemIdentifier: UserRank) {
        addimage(imageUrl: itemIdentifier.profileImage)
        updateUICommon(rank: itemIdentifier.boardRank, name: itemIdentifier.nickName, count: itemIdentifier.count)
    }

    private func updateUICommon(rank: Int, name: String, count: Int, isPost : Bool = false) {
        
        if isPost {
            boardNameLabel.snp.removeConstraints()
            profileImage.snp.removeConstraints()
            profileImage.image = nil
            
            boardNameLabel.snp.makeConstraints { make in
                make.centerY.equalTo(rankLabel)
                make.leading.equalToSuperview().inset(45)
            }
            
        }
        
        rankLabel.text = "\(rank + 1)."
        rankLabel.font = rank < 3 ? DesignSystem.mainFont.customFontHeavy(size: 18) : DesignSystem.mainFont.customFontMedium(size: 18)
        rankLabel.textColor = rank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.black
        
        boardNameLabel.text = name
        boardNameLabel.font = rank < 3 ? DesignSystem.mainFont.customFontHeavy(size: 18) : DesignSystem.mainFont.customFontMedium(size: 18)
        
        countLabel.text = "\(count)"
        countLabel.font = rank < 3 ? DesignSystem.mainFont.customFontHeavy(size: 15) : DesignSystem.mainFont.customFontMedium(size: 15)
        countLabel.backgroundColor = rank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.lightBlack
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = nil
        rankLabel.font = nil
        rankLabel.textColor = DesignSystem.commonColorSet.black
        
        profileImage.image = nil
        
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
                case .failure(let error):
                    print(error)
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
