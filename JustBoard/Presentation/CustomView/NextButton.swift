//
//  NextButton.swift
//  JustBoard
//
//  Created by JinwooLee on 4/16/24.
//

import UIKit

final class NextButton : UIButton {
    
    init(title : String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = DesignSystem.mainFont.customFontHeavy(size: 20)
        setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        backgroundColor = DesignSystem.commonColorSet.lightBlack
        layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
        setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
