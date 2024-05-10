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
    
    func showAlert2(title:String ,text: String, addButtonText1: String? = nil, addButtonText2: String? = nil, Action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        if let buttonText = addButtonText2 {
            let customAction = UIAlertAction(title: buttonText, style: .cancel) { _ in
            }
            alert.addAction(customAction)
        }
        
        
        if let buttonText = addButtonText1 {
            let customAction = UIAlertAction(title: buttonText, style: .destructive) { _ in
                Action?()
            }
            alert.addAction(customAction)
        }
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
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
    
    func setupSheetPresentationFlexible(height:Double) {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return height // your custom height
            })]
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
