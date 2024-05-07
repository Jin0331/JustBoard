//
//  UICollectionView+Extension.swift
//  JustBoard
//
//  Created by JinwooLee on 4/26/24.
//

import UIKit

extension UICollectionView {
    func isNearBottomEdge(edgeOffset: CGFloat) -> Bool {
        guard self.contentSize.height > 0 else { return false }
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
