//
//  BoardCollectionViewCell.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit
import Then
import SnapKit

final class BoardCollectionViewCell: BaseCollectionViewCell {
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    private let commentCount = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = DesignSystem.commonColorSet.lightBlack
    }
    
    private let author = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    
    private let createdAt = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    
    override func configureHierarchy() {
        [titleLabel, commentCount, author, createdAt].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(commentCount.snp.leading).offset(-10)
        }
        
        commentCount.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(createdAt)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        createdAt.snp.makeConstraints { make in
            make.verticalEdges.equalTo(author)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func updateUI(_ itemIdentifier : PostResponse) {
        
        titleLabel.text = itemIdentifier.title
        commentCount.text = String(itemIdentifier.comments.count)
        author.text = itemIdentifier.creator.nick
        
    }
}
