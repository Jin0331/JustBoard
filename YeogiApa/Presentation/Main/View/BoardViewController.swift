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
        
        let prefetchItems = mainView.mainCollectionView.rx.prefetchItems
            .compactMap(\.last?.row)
        
        let input = BoardViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            questionButtonTap:  mainView.questionButton.rx.tap,
            prefetchItems: prefetchItems
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                owner.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: disposeBag)

        
        output.postData
            .enumerated()
            .debug("postData")
            .bind(with: self) { owner, value in
                print(value.index, " emit index ✅")
                if value.index == 0 {
                    owner.updateSnapshot(value.element)
                } else {
                    owner.afterUpdateSnapshot(value.element)
                }
                
            }
            .disposed(by: disposeBag)
        
        output.questionButtonTap
            .drive(with: self) { owner, _ in
                print("question Button Tap ✅")
                owner.parentCoordinator?.toQuestion()
            }
            .disposed(by: disposeBag)
        
//        output.postData
//            .debug("postData")
//            .scan([]) { (previous, new) -> [PostResponse] in
//                return previous + new
//            }
//            .bind(with: self) { owner, value in
//                print(value.count, " postResponse count")
//                if value.count <= Int(InquiryRequest.InquiryRequestDefault.limit)! {
//                    owner.updateSnapshot(value)
//                } else {
//                    owner.afterUpdateSnapshot(value)
//                }
//                
//            }
//            .disposed(by: disposeBag)

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
        var snapshot = datasource.snapshot()
        snapshot.appendSections(BoardViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    func afterUpdateSnapshot(_ data : [PostResponse]) {
        
        let group = DispatchGroup()
        var snapshot = datasource.snapshot()
        let sortedData = data.sorted {
            $0.createdAtToTimeDate < $1.createdAtToTimeDate
        }
        
        group.enter()
        DispatchQueue.main.async(group: group) { [weak self] in
            guard let self = self else { return }
            mainView.setActivityIndicator()
            mainView.activityIndicator.startAnimating()
            
            print(snapshot.itemIdentifiers.count, "✅ old data")
            print(data.count, "✅ new Data")
            
            for newData in sortedData {
                if let index = snapshot.itemIdentifiers.firstIndex(where: { $0.postID == newData.postID }) {
                    snapshot.deleteItems([snapshot.itemIdentifiers[index]])
                    snapshot.insertItems([newData], afterItem: snapshot.itemIdentifiers[index])
                } else {
                    snapshot.appendItems([newData], toSection: .main)
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self]  in
                guard let self = self else { return }
                datasource.apply(snapshot, animatingDifferences: true)
                mainView.activityIndicator.stopAnimating()
                mainView.loadingBgView.removeFromSuperview()
                
            }
        }
    }
    
}

extension BoardViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        
        parentCoordinator?.toDetail(item)
    }
}
