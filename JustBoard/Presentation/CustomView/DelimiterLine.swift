//
//  DelimiterLine.swift
//  JustBoard
//
//  Created by JinwooLee on 4/20/24.
//

import UIKit

final class DelimiterLine: UIView {

    init(lightGray: Bool = true) {
        super.init(frame: .zero)
        backgroundColor = lightGray ? DesignSystem.commonColorSet.lightGray : DesignSystem.commonColorSet.gray
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
