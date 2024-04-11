//
//  BaseView.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { 
        backgroundColor = DesignSystem.colorSet.white
    }
}
