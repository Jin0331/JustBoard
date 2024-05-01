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

final class BoardRankCollectionViewCell : BaseCollectionViewCell, Reusable {
    
    private let rankLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = DesignSystem.commonColorSet.black
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
        [rankLabel, boardNameLabel, countLabel].forEach { contentView.addSubview($0)}
    }
    
    override func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        boardNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rankLabel)
            make.leading.equalTo(rankLabel.snp.trailing).offset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rankLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
    }
    
    func updateUI(_ itemIdentifier : PostRank) {
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
        rankLabel.text = String(itemIdentifier.boardRank + 1) + "."
        rankLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 18, weight: .heavy) : .systemFont(ofSize: 18, weight: .regular)
        rankLabel.textColor = itemIdentifier.boardRank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.black
        
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
        
        boardNameLabel.text = nil
        boardNameLabel.font = nil
        
        countLabel.text = nil
        countLabel.font = nil
        countLabel.backgroundColor = nil
    }
}
