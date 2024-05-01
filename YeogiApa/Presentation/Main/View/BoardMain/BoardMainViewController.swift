//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/1/24.
//

import UIKit

final class BoardMainViewController: RxBaseViewController {

    let baseView : BoardMainView
    var parentCoordinator : BoardCoordinator?
    private let viewModel : BoardMainViewModel
    private var dataSource: BoardRankRxDataSource!

    init(viewControllersList : Array<RxBaseViewController>, category : [Category], productId : String, limit : String){
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
