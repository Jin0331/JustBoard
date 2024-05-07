//
//  BoardListCollectionViewCell.swift
//  JustBoard
//
//  Created by JinwooLee on 5/5/24.
//

import UIKit
import Then
import SnapKit
import Reusable
import MarqueeLabel

final class BoardListCollectionViewCell: BaseCollectionViewCell, Reusable {
    
    let boardIconImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystem.sfSymbol.doc
        $0.tintColor = DesignSystem.commonColorSet.lightBlack
    }
    
    private let boardNameLabel =  MarqueeLabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    
    override func configureHierarchy() {
        [boardIconImage, boardNameLabel].forEach { contentView.addSubview($0)}
    }
    
    override func configureLayout() {
        boardIconImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(25)
        }
        
        boardNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(boardIconImage)
            make.leading.equalTo(boardIconImage.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func updateUI(_ itemIdentifier: String) {
        boardNameLabel.text = itemIdentifier
    }
}
