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
        
        baseView.menuBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let containerView = MenuViewController()
                containerView.sendDelegate = self
                owner.present(SideMenuNavigationController(rootViewController: containerView), animated: true)
            }
            .disposed(by: disposeBag)
        
        
        
        let input = BoardMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            dmButtonClicked : baseView.dmBarButtonItem.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                print("BoardMainViewController - viewWillApper✅")
                owner.tabBarController?.tabBar.isHidden = false
                owner.mainNavigationAttribute()
            }
            .disposed(by: disposeBag)
        
        output.myChatList
            .bind(with: self) { owner, myChatList in
                owner.parentCoordinator?.toChatList(chatlist: myChatList)
            }
            .disposed(by: disposeBag)
        
    }
}

//MARK: - SideMenu에서 선택한 VC 현재 Coordinator에 부착하기
extension BoardMainViewController : MenuViewControllerDelegate {
    
    private func attachSideMenuVC() {
        navigationItem.rightBarButtonItems = [baseView.menuBarButtonItem, baseView.dmBarButtonItem]
    }
    
    func sendProfileViewController(userID: String, me: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            parentCoordinator?.toProfile(userID: userID, me: me, defaultPage: 0)
        }
    }
}
