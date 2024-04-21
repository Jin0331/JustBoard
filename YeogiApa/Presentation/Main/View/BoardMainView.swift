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

    let questionButton = CompleteButton(title: "작성하기", image: DesignSystem.sfSymbol.question, fontSize: 15)
    
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
