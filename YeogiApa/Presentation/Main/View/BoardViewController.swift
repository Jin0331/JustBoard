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
        
        mainView.mainCollectionView.rx.prefetchItems
//            .compactMap(\.last?.row)
            .bind(with: self) { owner, indexPath in
                
                print(indexPath, "✅")
            }
            .disposed(by: disposeBag)
        
//        mainView.mainCollectionView.rx.didScroll.subscribe { [weak self] _ in
//            guard let self = self else { return }
//            let offSetY = mainView.mainCollectionView.contentOffset.y
//            let contentHeight = mainView.mainCollectionView.contentSize.height
//
//            print(offSetY)
//            print(contentHeight)
//            
//            if offSetY > (contentHeight - mainView.mainCollectionView.frame.size.height - 100) {
//                print(offSetY)
//            }
//        }
//        .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                owner.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: disposeBag)
        
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
        
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        
        parentCoordinator?.toDetail(item)
    }
}
