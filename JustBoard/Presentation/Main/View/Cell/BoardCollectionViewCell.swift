//
//  BoardCollectionViewCell.swift
//  JustBoard
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit
import Then
import SnapKit
import Reusable

final class BoardCollectionViewCell: BaseCollectionViewCell, Reusable {
    
    private let titleLabel = UILabel().then {
        $0.font = DesignSystem.mainFont.customFontBold(size: 18)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    private let commentCount = UILabel().then {
        $0.font = DesignSystem.mainFont.customFontSemiBold(size: 17)
        $0.textColor = DesignSystem.commonColorSet.lightBlack
    }
    
    private let author = UILabel().then {
        $0.font = DesignSystem.mainFont.customFontMedium(size: 15)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    
    private let createdAt = UILabel().then {
        $0.font = DesignSystem.mainFont.customFontMedium(size: 15)
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
            make.trailing.equalTo(createdAt.snp.leading).offset(-10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
        }
        
        createdAt.snp.makeConstraints { make in
            make.verticalEdges.equalTo(author)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func updateUI(_ itemIdentifier : PostResponse) {
        
        titleLabel.text = itemIdentifier.title
        commentCount.text = itemIdentifier.comments.count > 0 ? "[" + String(itemIdentifier.comments.count) + "]" : ""
        author.text = itemIdentifier.creator.nick
        createdAt.text = itemIdentifier.createdAt.formatDateString()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        commentCount.text = nil
        author.text = nil
        createdAt.text = nil
    }
}
