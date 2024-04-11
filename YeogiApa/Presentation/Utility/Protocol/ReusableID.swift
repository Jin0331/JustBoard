//
//  ReusableID.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit

extension UIView: ReusableID {
    
}

protocol ReusableID {
}

extension ReusableID {
    static var id: String {
        return String(describing: self)
    }
}
