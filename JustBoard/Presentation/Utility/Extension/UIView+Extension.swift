//
//  UIView+Extension.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI
import SnapKit

extension UIView {
    func addSwiftUIView<T: View>(view: T) {
        let hostingController = UIHostingController(rootView: view)
        addSubview(hostingController.view)
        
        hostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

