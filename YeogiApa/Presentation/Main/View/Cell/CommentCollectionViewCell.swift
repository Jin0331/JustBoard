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
            make.horizontalEdges.equalTo(author)
        }
        
        createdAt.snp.makeConstraints { make in
            make.top.equalTo(main.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(author)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
    func updateUI(_ itemIdentifier : Comment) {
                
        author.text = itemIdentifier.creator.nick
        main.text = itemIdentifier.content
        createdAt.text = itemIdentifier.createdAt
    }
}
