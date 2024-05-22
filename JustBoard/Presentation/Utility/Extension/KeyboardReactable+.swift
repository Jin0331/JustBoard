//
//  KeyboardReactable.swift
//  JustBoard
//
//  Created by JinwooLee on 5/23/24.
//

import UIKit
import RxCocoa
import RxSwift

// 키보드의 등장에 반응하여 ScrollView UI 변화
protocol KeyboardReactable: AnyObject {
  var scrollView: UIScrollView! { get set }
  var loadBag: DisposeBag { get set }
}

extension KeyboardReactable where Self: UIViewController {
  /// 키보드가 올라와 있는 상황에서 키보드 밖의 영역을 터치하면 키보드가 사라지도록 동작
  func setTapGesture() {
      let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
  }
  
  /// 키보드가 올라간 만큼 화면도 같이 스크롤
  func setKeyboardNotification() {
    let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)

    keyboardWillShow
      .asDriver(onErrorRecover: { _ in .never()})
      .drive(onNext: { [weak self] noti in
        self?.handleKeyboardWillShow(noti)
      }).disposed(by: loadBag)
    
    keyboardWillHide
      .asDriver(onErrorRecover: { _ in .never()})
      .drive(onNext: { [weak self] noti in
        self?.handleKeyboardWillHide()
      }).disposed(by: loadBag)
  }
  
  private func handleKeyboardWillShow(_ notification: Notification) {
      guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
              return
      }

      let contentInset = UIEdgeInsets(
          top: 0.0,
          left: 0.0,
          bottom: keyboardFrame.size.height,
          right: 0.0)
      scrollView.contentInset = contentInset
      scrollView.scrollIndicatorInsets = contentInset
  }

  private func handleKeyboardWillHide() {
      let contentInset = UIEdgeInsets.zero
      scrollView.contentInset = contentInset
      scrollView.scrollIndicatorInsets = contentInset
  }
}
