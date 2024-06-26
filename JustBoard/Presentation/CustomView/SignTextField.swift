//
//  SignTextfield.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import TextFieldEffects

final class SignTextField : JiroTextField {
    
    init(placeholderText : String) {
        super.init(frame: .zero)
        placeholder = placeholderText
        placeholderColor = DesignSystem.commonColorSet.lightBlack
        placeholderFontScale = 1
        borderColor = DesignSystem.commonColorSet.lightBlack
        textColor = .white
        font = DesignSystem.mainFont.customFontHeavy(size: 20)
        contentVerticalAlignment = .bottom
        layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
