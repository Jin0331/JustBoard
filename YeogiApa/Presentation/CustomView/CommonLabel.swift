//
//  CommonLabel.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/2/24.
//

import UIKit

final class CommonLabel : UILabel {
    
    init(title: String, fontSize: Double) {
        super.init(frame: .zero)
        text = title
        font = .systemFont(ofSize: fontSize, weight: .heavy)
        textColor = DesignSystem.commonColorSet.white
        backgroundColor = DesignSystem.commonColorSet.lightBlack
        textAlignment = .center
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
