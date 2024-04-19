//
//  DelimiterLine.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/20/24.
//

import UIKit

final class DelimiterLine: UIView {

    init() {
        super.init(frame: .zero)
        backgroundColor = DesignSystem.commonColorSet.lightGray
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
