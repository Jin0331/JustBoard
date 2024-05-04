//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewController
import SideMenu

final class BoardViewController: RxBaseViewController {
    
    private let mainView : BoardView
    private let viewModel : BoardViewModel
    private let productId : String
    var parentMainCoordinator : BoardMainCoordinator?
    var parentCoordinator : BoardSpecificCoordinator?
    private var dataSource: BoardRxDataSource!
    
    override func loadView() {
        view = mainView
    }
    
    init(productId : String, limit: String, bestBoard: Bool, bestBoardType : BestCategory?) {
        self.productId = productId
        self.mainView = BoardView(bestBoard: bestBoard)
        self.viewModel = BoardViewModel(product_id: productId,
                                        limit: limit,
                                        bestBoard: bestBoard,
                                        bestBoardType : bestBoardType
        )
        
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        attachSideMenuVC()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let prefetchItems = mainView.mainCollectionView.rx.prefetchItems
            .compactMap(\.last?.row)
        
        mainView.mainCollectionView.rx
            .modelAndIndexSelected(PostResponse.self)
            .bind(with: self) { owner, value in
                owner.parentCoordinator?.toDetail(value.0)
                owner.parentMainCoordinator?.toDetail(value.0)
            }
            .disposed(by: disposeBag)
        
        let input = BoardViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            questionButtonTap:  mainView.questionButton.rx.tap,
            prefetchItems: prefetchItems
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                owner.tabBarController?.tabBar.isHidden = false
                print("BoardViewController - viewWillApper✅")
            }
            .disposed(by: disposeBag)
        
        
        output.questionButtonTap
            .drive(with: self) { owner, _ in
                print("question Button Tap ✅", owner.productId)
                owner.parentCoordinator?.toQuestion(owner.productId)
            }
            .disposed(by: disposeBag)
        
        
        output.postData
            .bind(to: mainView.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationItem.title = productId + " 게시판"
    }
    
    deinit {
        print(#function, "- BoardViewController ✅")
    }
}
 
//MARK: - RxDataSource CollectionView
extension BoardViewController {
    private func configureCollectionViewDataSource() {
        
        dataSource = BoardRxDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell: BoardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.updateUI(item)
            
            return cell
        })
        
    }
}

//MARK: - SideMenu에서 선택한 VC 현재 Coordinator에 부착하기
extension BoardViewController : MenuViewControllerDelegate {
    
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
            parentCoordinator?.toProfile(userID: userID, me: me)
        }
    }
}
