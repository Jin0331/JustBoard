//
//  SignInUpViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInUpViewController : RxBaseViewController{
    
    private let mainView = SignInUpView()
    
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}
