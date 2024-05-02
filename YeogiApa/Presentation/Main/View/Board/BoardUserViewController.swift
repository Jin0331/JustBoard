//
//  BoardUserViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewController

final class BoardUserViewController: RxBaseViewController {
    
    private let mainView = BoardUserView()
    private let viewModel : BoardUserViewModel
    var parentCoordinator : BoardUserCoordinator?
    private var dataSource: BoardRxDataSource!
    
    override func loadView() {
        view = mainView
    }
    
    init(userPostId : [String]) {
        self.viewModel = BoardUserViewModel(userPostId: userPostId)
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        mainView.mainCollectionView.rx
            .modelAndIndexSelected(PostResponse.self)
            .bind(with: self) { owner, value in
                owner.parentCoordinator?.toDetail(value.0)
            }
            .disposed(by: disposeBag)
        
        let input = BoardUserViewModel.Input(
            viewWillAppear: rx.viewWillAppear
        )
        
        let output = viewModel.transform(input: input)
        output.postData
            .bind(to: mainView.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}


//MARK: - RxDataSource CollectionView
extension BoardUserViewController {
   private func configureCollectionViewDataSource() {
       
       dataSource = BoardRxDataSource(configureCell: { dataSource, collectionView, indexPath, item in
           
           let cell: BoardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
           cell.updateUI(item)
           
           return cell
       })
       
   }
}
