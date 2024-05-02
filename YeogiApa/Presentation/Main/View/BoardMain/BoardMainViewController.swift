//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BoardMainViewController: RxBaseViewController {

    let baseView : BoardMainView
    var parentCoordinator : BoardMainCoordinator?
    private let viewModel : BoardMainViewModel
    private var postRankDataSource: BoardRankRxDataSource!
    private var userRankDataSource: BoardRankRxDataSource!

    init(viewControllersList : Array<RxBaseViewController>, category : [BestCategory], productId : String, limit : String){
        self.viewModel = BoardMainViewModel(product_id: productId, limit: limit)
        
        let tabmanVC = BoardTabmanViewController(viewControllersList: viewControllersList,
                                                 category: category, 
                                                 productId: productId, limit: limit)
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
            }
            .disposed(by: disposeBag)
        
        output.postData
            .bind(to: baseView.postRankCollectionView.rx.items(dataSource: postRankDataSource))
            .disposed(by: disposeBag)
        
        output.postData
            .bind(to: baseView.userRankCollectionView.rx.items(dataSource: userRankDataSource))
            .disposed(by: disposeBag)
        
        output.userPost
            .bind(with: self) { owner, userPost in
                
                print(userPost.first)
                
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        navigationItem.title = "Bulletin Board"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "MarkerFelt-Thin", size: 25)!
        ]
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
