//
//  UIViewController+Extension.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit

//MARK: - RootView Change
extension UIViewController {
    func changeRootView(to viewController: UIViewController, isNav: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let vc = isNav ? UINavigationController(rootViewController: viewController) : viewController
        
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }
}

//MARK: - Common Alert
extension UIViewController {
    
    func showAlert(title:String ,text: String, addButtonText: String? = nil, Action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        if let buttonText = addButtonText {
            let customAction = UIAlertAction(title: buttonText, style: .default) { _ in
                Action?()
            }
            alert.addAction(customAction)
        }
        
        present(alert, animated: true)
    }
}

//MARK: - Present
extension UIViewController {
    func setupSheetPresentationFlexible() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium(),.large()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    func setupSheetPresentationLarge() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    func setupSheetPresentationMedium() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
    }
}
