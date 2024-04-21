//
//  CompleteButton.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/22/24.
//

import UIKit

final class CompleteButton : UIButton {
    
    init(title: String, image: UIImage?, fontSize: Double, disable : Bool = false) {
        super.init(frame: .zero)
        setTitle(" \(title)", for: .normal)
        titleLabel?.font = .systemFont(ofSize: fontSize, weight: .heavy)
        setImage(image, for: .normal)
        tintColor = DesignSystem.commonColorSet.white
        setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        backgroundColor = DesignSystem.commonColorSet.black
        layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
        
        if disable {
            isEnabled = !disable
            alpha = !disable ? 1.0 : 0.5
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
