//
//  BoardMainViewController.swift
//  JustBoard
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
    
    private let baseView : BoardView
    private let viewModel : BoardViewModel
    private let productId : String
    private let bestBoard : Bool
    var parentPorifleCoordinator : ProfileCoordinator?
    var parentMainCoordinator : BoardMainCoordinator?
    var parentCoordinator : BoardSpecificCoordinator?
    private var dataSource: BoardRxDataSource!
    
    override func loadView() {
        view = baseView
    }
    
    init(productId : String, userID : String? = nil, limit: String, bestBoard: Bool, profileBoard: Bool, bestBoardType : BestCategory? = nil, profileBoardType : ProfilePostCategory? = nil) {
        self.productId = productId
        self.bestBoard = bestBoard
        self.baseView = BoardView(bestBoard: bestBoard, profileBoard: profileBoard)
        self.viewModel = BoardViewModel(product_id: productId,
                                        userId: userID,
                                        limit: limit,
                                        bestBoard: bestBoard,
                                        profileBoard: profileBoard,
                                        bestBoardType : bestBoardType,
                                        profileBoardType: profileBoardType
        )
        
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        attachSideMenuVC()
        baseView.mainCollectionView.delegate = self
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let prefetchItems = baseView.mainCollectionView.rx.prefetchItems
            .compactMap(\.last?.row)
        
        baseView.mainCollectionView.rx
            .modelAndIndexSelected(PostResponse.self)
            .bind(with: self) { owner, value in
                owner.parentCoordinator?.toDetail(value.0)
                owner.parentMainCoordinator?.toDetail(value.0)
                owner.parentPorifleCoordinator?.toDetail(value.0)
            }
            .disposed(by: disposeBag)
        
        let input = BoardViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            questionButtonTap:  baseView.questionButton.rx.tap,
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
                owner.parentCoordinator?.toQuestion(owner.productId)
            }
            .disposed(by: disposeBag)
        
        
        output.postData
            .bind(to: baseView.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationItem.title = productId + " 게시판"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: DesignSystem.commonColorSet.black
        ]
    }
    
    deinit {
        print(#function, "- BoardViewController ✅")
    }
}
 
//MARK: - RxDataSource CollectionView
extension BoardViewController {
    private func configureCollectionViewDataSource() {
        
        dataSource = BoardRxDataSource(configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            
            let cell: BoardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if bestBoard {
                cell.updateUIBestBoard(item)
            } else {
                cell.updateUI(item)
            }
            
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
            parentCoordinator?.toProfile(userID: userID, me: me, defaultPage: 0)
        }
    }
}

extension BoardViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return configureContextMenu(index: indexPath)
    }
    
    func configureContextMenu(index: IndexPath) -> UIContextMenuConfiguration {
        let cell = dataSource[index]
        var menuItems: [UIMenuElement] = []
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] action -> UIMenu? in
            
            guard let self = self else { return nil }
            let me = cell.creator.userID == UserDefaultManager.shared.userId

            let profile = UIAction(title: "'" + cell.creator.nick + "' 프로필 조회하기", image: DesignSystem.tabbarImage.second, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self.parentCoordinator?.toProfile(userID: cell.creator.userID, me: me, defaultPage: 0)
                self.parentMainCoordinator?.toProfile(userID: cell.creator.userID, me: me, defaultPage: 0)
            }
            
            menuItems.append(profile)
            
            let dm = UIAction(title: "'" + cell.creator.nick + "'님과 대화하기", image: DesignSystem.sfSymbol.dm, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                
                NetworkManager.shared.createChatCompletion(query: ChatRequest(opponent_id: cell.creator.userID)) { chat in
                    self.parentCoordinator?.toChat(chat: chat)
                    self.parentMainCoordinator?.toChat(chat: chat)
                }
            }
            
            menuItems.append(dm)
            
            if bestBoard {
                let board = UIAction(title: "'" + cell.productID + "' 게시판 조회하기", image: DesignSystem.sfSymbol.doc, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self.parentMainCoordinator?.toSpecificBoard(cell.productID)
                }
                
                menuItems.append(board)
            }
            
            return UIMenu(title: "탐색", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: menuItems)
        }
        
        return context
    }
}
