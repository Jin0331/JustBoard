//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController
import Alamofire

final class BoardViewController: RxBaseViewController {
    
    private let mainView = BoardView()
    private let viewModel = BoardViewModel()
    var parentCoordinator : BoardCoordinator?
    private var datasource : BoardDataSource!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.mainCollectionView.delegate = self
        configureDataSource()
    }
    
    override func bind() {
        
        let input = BoardViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            questionButtonTap:  mainView.questionButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.postData
            .bind(with: self) { owner, post in
                
                dump(post)
                owner.updateSnapshot(post)
            }
            .disposed(by: disposeBag)
        
        output.questionButtonTap
            .drive(with: self) { owner, _ in
                print("question Button Tap ✅")
                owner.parentCoordinator?.toQuestion()
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Collection View 관련
extension BoardViewController : DiffableDataSource {
    func configureDataSource() {
        let cellRegistration = mainView.boardCellRegistration()
        datasource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.updateUI(itemIdentifier)
            
            return cell
        })
    }
    
    func updateSnapshot(_ data : [PostResponse]) {
        var snapshot = BoardDataSourceSnapshot()
        snapshot.appendSections(BoardViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        datasource.apply(snapshot)
    }
}

extension BoardViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        parentCoordinator?.toDetail()
    }
}
