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
        setHierarchy()
        setupAttributes()
        setupLayout()
        setupData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setHierarchy() { }
    
    func setupData() { }
    

    func setupLayout() {
    }
    

    func setupAttributes() {
    }
    

}
