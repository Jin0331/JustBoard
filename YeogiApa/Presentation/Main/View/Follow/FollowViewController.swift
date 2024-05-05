//
//  FollowViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewController

final class FollowViewController: RxBaseViewController {

    private let baseView = FollowView()
    private let me : Bool
    private let viewModel : FollowViewModel
    var parentCoordinator : FollowCoordinator?
    private var dataSource: FollowRxDataSource!
    
    init(userID : String, me : Bool, follower : Bool, following : Bool) {
        self.me = me
        self.viewModel = FollowViewModel(userID: BehaviorSubject<String>(value: userID),
                                         me: me, follower: follower, following: following)
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = FollowViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.followData
            .bind(to: baseView.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

//MARK: - RxDataSource CollectionView
extension FollowViewController {
    private func configureCollectionViewDataSource() {
        
        dataSource = FollowRxDataSource(configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            
            guard let self = self else { return UICollectionViewCell()}
            
            let cell: FollowCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.updateUI(item)
            
            // Profile Coordinator
            cell.profileButton.rx.tap
                .bind(with: self) { owner, _ in
                    
                    guard let myID = UserDefaultManager.shared.userId else { return }
                    let checkUserId = item.userID == myID
                    
                    owner.parentCoordinator?.toProfile(userID: item.userID, me: checkUserId)
                }
                .disposed(by: disposeBag)
            
            
            return cell
        })
        
    }
}
