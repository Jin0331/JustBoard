//
//  CommentCollectionViewCell.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/25/24.
//

import UIKit
import Then
import SnapKit

final class CommentCollectionViewCell: BaseCollectionViewCell {
    private let author = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    
    private let main = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    private let createdAt = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    
    override func configureHierarchy() {
        [main, author, createdAt].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        author.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        main.snp.makeConstraints { make in
            make.top.equalTo(author.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualTo(createdAt.snp.top).offset(-10)
            make.horizontalEdges.equalTo(author)
        }
        
        createdAt.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(author)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
    }
    
    func updateUI(_ itemIdentifier : Comment) {
        contentView.layer.addBorder([.top], color: DesignSystem.commonColorSet.lightGray, width: 1)
        author.text = itemIdentifier.creator.nick
        main.text = itemIdentifier.content
        createdAt.text = itemIdentifier.createdAt
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        author.text = nil
        main.text = nil
        createdAt.text = nil
    }
}
