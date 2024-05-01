//
//  BoardDetailViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

final class BoardDetailViewController: RxBaseViewController {

    private let mainView = BoardDetailView()
    private let viewModel : BoardDetailViewModel
    var parentCoordinator : BoardCoordinator?
    private var datasource : BoardDetailDataSource!
    
    override func loadView() {
        view = mainView
        tabBarController?.tabBar.isHidden = true
    }
    
    init(postResponse : PostResponse) {
        self.viewModel = BoardDetailViewModel(postResponse)
    }

    override func viewDidLoad() {
        mainView.commentCollectionView.delegate = self
        configureDataSource()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .bind(with: self) { owner, _ in
                owner.mainView.scrollView.isScrollEnabled = true
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .bind(with: self) { owner, _ in
                owner.mainView.scrollView.isScrollEnabled = false
            }
            .disposed(by: disposeBag)
        
        mainView.commentCountButton.rx.tap
            .bind(with: self) { owner, _ in
                let desiredYPosition = owner.mainView.commentCollectionView.frame.origin.y
                
                // 스크롤 이동 애니메이션
                UIView.animate(withDuration: 0.3) {
                    owner.mainView.scrollView.contentOffset = CGPoint(x: 0, y: desiredYPosition)
                }
            }
            .disposed(by: disposeBag)
        

        
        let input = BoardDetailViewModel.Input(
            likeButton: mainView.likeButton.rx.tap,
            commentText: mainView.commentTextField.rx.text.orEmpty,
            commentComplete: mainView.commentCompleteButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.commentButtonUI
            .drive(with: self) { owner, valid in
                owner.mainView.commentCompleteButton.isHidden = !valid
            }
            .disposed(by: disposeBag)
        
        output.postData
            .bind(with: self) { owner, postData in
                owner.mainView.updateUI(postData)
                owner.updateSnapshot(postData.comments)
            }
            .disposed(by: disposeBag)
        
        output.updatedPost
            .bind(with: self) { owner, postData in
                owner.mainView.likeUpdateUI(postData)
                owner.mainView.commentUpdateUI(postData)
                owner.updateSnapshot(postData.comments)
            }
            .disposed(by: disposeBag)
        
        output.commentComplete
            .drive(with: self) { owner, valid in
                owner.view.endEditing(true)
                owner.mainView.commentTextField.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print(#function, "- BoardDetailViewController ✅")
    }
}

//MARK: - Collection View 관련
extension BoardDetailViewController : DiffableDataSource, UICollectionViewDelegate {
    func configureDataSource() {
        let cellRegistration = mainView.boardDetailCellRegistration()
        datasource = UICollectionViewDiffableDataSource(collectionView: mainView.commentCollectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.updateUI(itemIdentifier)
            
            return cell
        })
    }
    
    func updateSnapshot(_ data : [Comment]) {
        
        var snapshot = BoardDetailDataSourceSnapshot()
        snapshot.appendSections(BoardDetailViewSection.allCases)
        
        let uniqueItemsToAdd = data.filter { !snapshot.itemIdentifiers.contains($0) }
        snapshot.appendItems(uniqueItemsToAdd, toSection: .main)
        
        datasource.apply(snapshot)
    }
}
