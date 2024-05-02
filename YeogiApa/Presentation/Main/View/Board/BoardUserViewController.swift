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
    
    init(userPost : [PostResponse]) {
        self.viewModel = BoardUserViewModel(userPost: userPost)
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = BoardUserViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
    }
    
    override func configureView() {
        view.backgroundColor = .red
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
