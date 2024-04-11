//
//  BaseViewController.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//
 
import UIKit
import RxSwift
import RxCocoa

class RxBaseViewController : BaseViewController {
    let disposeBag = DisposeBag()
}

class BaseViewController: UIViewController {
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigation()
        bind()
    }
    
    
    func bind() { }
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() {
        view.backgroundColor = DesignSystem.colorSet.white
    }
    
    func configureNavigation() {
                
        // back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
