//
//  BoardRankViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

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
            
            baseView.rankCollectionView.rx.longPressGesture()
                .when(.ended)
                .bind(with: self) { owner, sender in
                    
                    let point = sender.location(in: owner.baseView.rankCollectionView)
                    if let indexPath = owner.baseView.rankCollectionView.indexPathForItem(at: point) {
                        // get the cell at indexPath (the one you long pressed)
                        
                        let temp = owner.dataSource[indexPath]
                        print(temp.userRank.userId, temp.userRank.nickName)
                    }
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
