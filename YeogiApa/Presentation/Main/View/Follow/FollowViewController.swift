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
}

//MARK: - RxDataSource CollectionView
extension FollowViewController {
    private func configureCollectionViewDataSource() {
        
        dataSource = FollowRxDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell: FollowCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.updateUI(item)
            
            return cell
        })
        
    }
}
