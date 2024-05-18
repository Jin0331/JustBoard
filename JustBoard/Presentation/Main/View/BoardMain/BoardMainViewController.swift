//
//  BoardMainViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

final class BoardMainViewController: RxBaseViewController {
    
    let baseView : BoardMainView
    var parentCoordinator : BoardMainCoordinator?
    private let viewModel : BoardMainViewModel
    
    init(bestViewControllersList : Array<RxBaseViewController>, userViewControllerList : Array<RxBaseViewController>){
        self.viewModel = BoardMainViewModel()
        
        let tabmanVC = BoardTabmanViewController(viewControllersList: bestViewControllersList, category: .best)
        let tabmanUserVC = BoardTabmanViewController(viewControllersList: userViewControllerList, category: .user)
        self.baseView = BoardMainView(tabmanVC: tabmanVC, tabmanUserVC:tabmanUserVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        attachSideMenuVC()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = BoardMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                print("BoardMainViewController - viewWillApper✅")
                owner.tabBarController?.tabBar.isHidden = false
                owner.mainNavigationAttribute()
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - SideMenu에서 선택한 VC 현재 Coordinator에 부착하기
extension BoardMainViewController : MenuViewControllerDelegate {
    
    private func attachSideMenuVC() {
        // left button
        let menuBarButtonItem = UIBarButtonItem(image: DesignSystem.sfSymbol.list?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtonItemTapped)).then {
            $0.tintColor = DesignSystem.commonColorSet.black
        }

        let dmBarButtonItem = UIBarButtonItem(image: DesignSystem.sfSymbol.dm?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(dmBarButtonItemTapped)).then {
            $0.tintColor = DesignSystem.commonColorSet.black
        }
        
        navigationItem.rightBarButtonItems = [menuBarButtonItem, dmBarButtonItem]
    }

    @objc private func menuBarButtonItemTapped() {
        let containerView = MenuViewController()
        containerView.sendDelegate = self
        present(SideMenuNavigationController(rootViewController: containerView), animated: true)
    }
    
    @objc private func dmBarButtonItemTapped() {
        parentCoordinator?.toChatList()
    }
    
    func sendProfileViewController(userID: String, me: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            parentCoordinator?.toProfile(userID: userID, me: me, defaultPage: 0)
        }
    }
}
