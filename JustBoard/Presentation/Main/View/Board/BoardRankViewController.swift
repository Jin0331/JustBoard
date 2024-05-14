//
//  BoardRankViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BoardRankViewController: RxBaseViewController {

    let baseView : BoardRankView
    private let viewModel : BoardRankViewModel
    var parentCoordinator : BoardMainCoordinator?
    private let boardType : BestUserCategory
    private var dataSource: BoardRankRxDataSource!
    
    
    init(productId : String, limit: String, boardType: BestUserCategory) {
        self.baseView = BoardRankView()
        self.boardType = boardType
        self.viewModel = BoardRankViewModel(product_id: productId, limit: limit)
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        baseView.rankCollectionView.delegate = self
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let userProfileInquiry = PublishSubject<String>()
        
        switch boardType {
        case .user:
            baseView.rankCollectionView.rx
                .modelAndIndexSelected((postRank:PostRank, userRank:UserRank).self)
                .bind(with: self) { owner, value in
                    userProfileInquiry.onNext(value.0.userRank.userId)
                }
                .disposed(by: disposeBag)
            
            
        case .board:
            baseView.rankCollectionView.rx
                .modelAndIndexSelected((postRank:PostRank, userRank:UserRank).self)
                .bind(with: self) { owner, value in
                    owner.parentCoordinator?.toSpecificBoard(value.0.postRank.productId)
                }
                .disposed(by: disposeBag)
        }
        
        let input = BoardRankViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            userProfileInquiry: userProfileInquiry
        )
        
        let output = viewModel.transform(input: input)
        
        output.postData
            .bind(to: baseView.rankCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.userProfile
            .bind(with: self) { owner, userProfile in
                owner.parentCoordinator?.toUser(userProfile)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - RxDataSource CollectionView
extension BoardRankViewController {
    private func configureCollectionViewDataSource() {
        
        dataSource = BoardRankRxDataSource(configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            
            guard let self else { return UICollectionViewCell() }
            
            let cell: BoardRankCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            
            switch boardType {
            case .user:
                cell.updateUI(item.userRank)
            case .board:
                cell.updateUI(item.postRank)
            }
            return cell
        })
        
    }
}

extension BoardRankViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch boardType {
        case .user:
            return configureContextMenu(index: indexPath)
        case .board:
            return nil
        }
    }
    
    func configureContextMenu(index: IndexPath) -> UIContextMenuConfiguration {
        let cell = dataSource[index]
        var menuItems: [UIMenuElement] = []
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] action -> UIMenu? in
            guard let self = self else { return nil }
            let me = cell.userRank.userId == UserDefaultManager.shared.userId
            
            let profile = UIAction(title: "프로필 조회하기", image: DesignSystem.tabbarImage.second, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self.parentCoordinator?.toProfile(userID: cell.userRank.userId, me: me, defaultPage: 0)
            }
            
            menuItems.append(profile)
            return UIMenu(title: "유저 탐색", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: menuItems)
        }
        
        return context
    }
}
