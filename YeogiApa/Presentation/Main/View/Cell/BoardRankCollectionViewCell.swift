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
    
    override func configureHierarchy() {
        [rankLabel, boardNameLabel].forEach { contentView.addSubview($0)}
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
    }
    
    func updateUI(_ itemIdentifier : PostRank) {
        rankLabel.text = String(itemIdentifier.boardRank + 1) + "."
        rankLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 18, weight: .bold) : .systemFont(ofSize: 18, weight: .regular)
        rankLabel.textColor = itemIdentifier.boardRank < 3 ? DesignSystem.commonColorSet.red : DesignSystem.commonColorSet.black
        
        boardNameLabel.text = itemIdentifier.productId
        boardNameLabel.font = itemIdentifier.boardRank < 3 ? .systemFont(ofSize: 18, weight: .bold) : .systemFont(ofSize: 18, weight: .regular)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = nil
        rankLabel.font = nil
        rankLabel.textColor = DesignSystem.commonColorSet.black
        boardNameLabel.text = nil
    }
}
