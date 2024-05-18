//
//  BaseViewController.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxViewController

class RxBaseViewController : BaseViewController {
    let disposeBag = DisposeBag()
}

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigation()
        bind()
    }
    
    
    func bind() { }
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    
    func configureNavigation() {
        // back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = DesignSystem.commonColorSet.lightBlack
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func mainNavigationAttribute() {
        let label = UILabel()
        label.textColor = DesignSystem.commonColorSet.black
        label.font = DesignSystem.mainFont.customFontHeavy(size: 25)
        label.text = "자게? 아니 자게!"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        navigationController?.navigationBar.barTintColor = DesignSystem.commonColorSet.white
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
