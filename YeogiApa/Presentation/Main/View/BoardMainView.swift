//
//  BoardMainView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import Then
import SnapKit

class BoardMainView: BaseView {

    let questionButton = UIButton().then {
        $0.setTitle(" 작성하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.setImage(DesignSystem.sfSymbol.question, for: .normal)
        $0.tintColor = DesignSystem.commonColorSet.white
        $0.setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        $0.backgroundColor = DesignSystem.commonColorSet.black
        $0.layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
    }
    
    
    override func configureHierarchy() {
        addSubview(questionButton)
    }
    
    override func configureLayout() {
        questionButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.width.equalTo(110)
        }
    }
}
