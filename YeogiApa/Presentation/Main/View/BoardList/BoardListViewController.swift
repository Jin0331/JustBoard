//
//  BoardListViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewController
import SideMenu

final class BoardListViewController: RxBaseViewController {

    private let baseView : BoardListView
    private let viewModel : BoardListViewModel
    var parentCoordinator : BoardListCoordinator?
    private var dataSource: BoardListRxDataSource!
    
    init(productId: String) {
        self.baseView = BoardListView()
        self.viewModel = BoardListViewModel(product_id: productId)
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = BoardListViewModel.Input(viewWillAppear: rx.viewWillAppear)
        
        baseView.mainCollectionView.rx
            .modelAndIndexSelected(String.self)
            .bind(with: self) { owner, value in
                owner.parentCoordinator?.toSpecificBoard(value.0)
            }
            .disposed(by: disposeBag)
        
        
        let output = viewModel.transform(input: input)
        
        output.postData
            .bind(to: baseView.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}


//MARK: - RxDataSource CollectionView
extension BoardListViewController {
   private func configureCollectionViewDataSource() {
       
       dataSource = BoardListRxDataSource(configureCell: { dataSource, collectionView, indexPath, item in
           
           let cell: BoardListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
           cell.updateUI(item)
           
           return cell
       })
       
   }
}
