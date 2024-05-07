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
    private var postRankDataSource: BoardRankRxDataSource!
    private var userRankDataSource: BoardRankRxDataSource!

    init(viewControllersList : Array<RxBaseViewController>, category : TabmanCategory, productId : String, limit : String){
        self.viewModel = BoardMainViewModel(product_id: productId, limit: limit)
        
        let tabmanVC = BoardTabmanViewController(viewControllersList: viewControllersList, category: category)
        self.baseView = BoardMainView(tabmanViewController: tabmanVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        attachSideMenuVC()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let userProfileInquiry = PublishSubject<String>()
        
        baseView.postRankCollectionView.rx
            .modelAndIndexSelected((postRank:PostRank, userRank:UserRank).self)
            .bind(with: self) { owner, value in
                owner.parentCoordinator?.toSpecificBoard(value.0.postRank.productId)
            }
            .disposed(by: disposeBag)
        
        // User Profile 조회 -> PostResponse -> transition
        baseView.userRankCollectionView.rx
            .modelAndIndexSelected((postRank:PostRank, userRank:UserRank).self)
            .bind(with: self) { owner, value in
                userProfileInquiry.onNext(value.0.userRank.userId)
            }
            .disposed(by: disposeBag)
        
        let input = BoardMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            userProfileInquiry: userProfileInquiry
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                print("BoardMainViewController - viewWillApper✅")
                owner.tabBarController?.tabBar.isHidden = false
                owner.mainNavigationAttribute()
            }
            .disposed(by: disposeBag)
        
        output.postData
            .bind(to: baseView.postRankCollectionView.rx.items(dataSource: postRankDataSource))
            .disposed(by: disposeBag)
        
        output.postData
            .bind(to: baseView.userRankCollectionView.rx.items(dataSource: userRankDataSource))
            .disposed(by: disposeBag)
        
        output.userProfile
            .bind(with: self) { owner, userProfile in
                owner.parentCoordinator?.toUser(userProfile)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - RxDataSource CollectionView
extension BoardMainViewController {
    private func configureCollectionViewDataSource() {
        
        postRankDataSource = BoardRankRxDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell: BoardRankCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)            
            cell.updateUI(item.postRank)
            
            return cell
        })
        
        userRankDataSource = BoardRankRxDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell: BoardRankCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.updateUI(item.userRank)
            
            return cell
        })
        
    }
}

//MARK: - SideMenu에서 선택한 VC 현재 Coordinator에 부착하기
extension BoardMainViewController : MenuViewControllerDelegate {
    
    private func attachSideMenuVC() {
        // left button
        let menuBarButtonItem = UIBarButtonItem(image: DesignSystem.sfSymbol.list?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtonItemTapped)).then {
            $0.tintColor = DesignSystem.commonColorSet.lightBlack
        }
        navigationItem.setRightBarButton(menuBarButtonItem, animated: true)
    }

    @objc private func menuBarButtonItemTapped() {
        let containerView = MenuViewController()
        containerView.sendDelegate = self
        present(SideMenuNavigationController(rootViewController: containerView), animated: true)
    }
    
    func sendProfileViewController(userID: String, me: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            parentCoordinator?.toProfile(userID: userID, me: me, defaultPage: 0)
        }
    }
}
