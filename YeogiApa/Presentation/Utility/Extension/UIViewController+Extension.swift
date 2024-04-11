//
//  UIViewController+Extension.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit

extension UIViewController {
    func changeRootView(to viewController: UIViewController, isNav: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let vc = isNav ? UINavigationController(rootViewController: viewController) : viewController
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }
}
