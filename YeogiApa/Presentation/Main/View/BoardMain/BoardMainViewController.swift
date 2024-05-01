//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/1/24.
//

import UIKit

final class BoardMainViewController: RxBaseViewController {

    let baseView = BoardMainView()
    var parentCoordinator : BoardCoordinator?
    private let viewControllers: Array<RxBaseViewController>
    private let category : [Category]
    private let viewModel : BoardMainViewModel
    private var dataSource: BoardRankRxDataSource!

    init(viewControllersList : Array<RxBaseViewController>, category : [Category], productId : String, limit : String){
        self.viewControllers = viewControllersList
        self.category = category
        self.viewModel = BoardMainViewModel(product_id: productId, limit: limit)
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
        let input = BoardMainViewModel.Input(viewWillAppear: rx.viewWillAppear)
        
        let output = viewModel.transform(input: input)
        
        output.postData
            .debug("postData")
            .bind(to: baseView.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

//MARK: - RxDataSource CollectionView
extension BoardMainViewController {
    private func configureCollectionViewDataSource() {
        
        dataSource = BoardRankRxDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell: BoardRankCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.updateUI(item)
            
            return cell
        })
        
    }
}
