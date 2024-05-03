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
import SideMenu

class RxBaseViewController : BaseViewController {
    let disposeBag = DisposeBag()
}

class BaseViewController: UIViewController {
    
    //MARK: - SideMenu
    var menu : SideMenuNavigationController?
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: DesignSystem.sfSymbol.list?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtonItemTapped)).then {
        $0.tintColor = DesignSystem.commonColorSet.lightBlack
    }
    
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
    func configureView() {  }
    
    func configureNavigation() {
        // back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = DesignSystem.commonColorSet.lightBlack
        navigationItem.backBarButtonItem = backBarButtonItem
        
        // left button
        navigationItem.setRightBarButton(menuBarButtonItem, animated: true)
        
        // side menu
        menu = SideMenuNavigationController(rootViewController: MenuViewController())
    }
    
    func mainNavigationAttribute() {
        navigationItem.title = "Bulletin Board"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: DesignSystem.mainFont.large!
        ]
    }
    
    @objc func menuBarButtonItemTapped() {
        present(menu!, animated: true)
    }
    
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
