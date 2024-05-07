//
//  MenuCollectionViewCell.swift
//  JustBoard
//
//  Created by JinwooLee on 5/3/24.
//

import UIKit
import Then
import SnapKit

final class MenuCollectionViewCell: BaseCollectionViewCell {
    
    private let iconImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = DesignSystem.commonColorSet.white
    }
    
    private let menuTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .heavy)
        $0.backgroundColor = .clear
        $0.textColor = DesignSystem.commonColorSet.white
    }
    
    override func configureHierarchy() {
        [iconImage, menuTitle].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        iconImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView).inset(20)
            make.size.equalTo(25)
        }
        
        menuTitle.snp.makeConstraints { make in
            make.centerY.equalTo(iconImage)
            make.leading.equalTo(iconImage.snp.trailing).offset(15)
        }
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func updateUI(_ itemIdentifier : MenuCase) {
        iconImage.image = itemIdentifier.iconImage
        menuTitle.text = itemIdentifier.rawValue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImage.image = nil
        menuTitle.text = nil
    }
}
