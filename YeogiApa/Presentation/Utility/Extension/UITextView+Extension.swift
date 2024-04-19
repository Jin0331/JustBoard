//
//  UITextView+Extension.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/20/24.
//

import UIKit

extension UITextView {
    func alignTextVerticallyInContainer() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        self.contentInset.top = topCorrect
        self.contentInset.left = 10
        self.contentInset.bottom = 0
    }
}
