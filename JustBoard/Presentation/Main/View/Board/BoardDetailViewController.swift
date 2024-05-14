//
//  BoardDetailViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

final class BoardDetailViewController: RxBaseViewController {

    private let baseView = BoardDetailView()
    private let viewModel : BoardDetailViewModel
    var parentCoordinator : BoardDetailCoordinator?
    private var datasource : BoardDetailDataSource!
    
    override func loadView() {
        view = baseView
        tabBarController?.tabBar.isHidden = true
    }
    
    init(postResponse : PostResponse) {
        self.viewModel = BoardDetailViewModel(postResponse)
    }

    override func viewDidLoad() {
        baseView.commentCollectionView.delegate = self
        configureDataSource()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .bind(with: self) { owner, _ in
                owner.baseView.scrollView.isScrollEnabled = true
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .bind(with: self) { owner, _ in
                owner.baseView.scrollView.isScrollEnabled = false
            }
            .disposed(by: disposeBag)
        
        baseView.commentCountButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.baseView.commentTextField.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        

        
        let input = BoardDetailViewModel.Input(
            profileButton : baseView.profileButton.rx.tap,
            likeButton: baseView.likeButton.rx.tap,
            unlikeButton: baseView.unlikeButton.rx.tap,
            commentText: baseView.commentTextField.rx.text.orEmpty,
            commentComplete: baseView.commentCompleteButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.profileType
            .bind(with: self) { owner, profileType in
                owner.parentCoordinator?.toProfile(userID: profileType.userID, me: profileType.me)
            }
            .disposed(by: disposeBag)
        
        output.commentButtonUI
            .drive(with: self) { owner, valid in
                owner.baseView.commentCompleteButton.isHidden = !valid
            }
            .disposed(by: disposeBag)
        
        output.postData
            .bind(with: self) { owner, postData in
                owner.baseView.updateUI(postData)
                owner.updateSnapshot(postData.comments)
            }
            .disposed(by: disposeBag)
        
        output.updatedPost
            .bind(with: self) { owner, postData in
                owner.baseView.likeUpdateUI(postData)
                owner.baseView.commentUpdateUI(postData)
                owner.updateSnapshot(postData.comments)
            }
            .disposed(by: disposeBag)
        
        output.commentComplete
            .drive(with: self) { owner, valid in
                owner.view.endEditing(true)
                owner.baseView.commentTextField.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: DesignSystem.commonColorSet.black
        ]
    }
    
    deinit {
        print(#function, "- BoardDetailViewController ✅")
    }
}

//MARK: - Collection View 관련
extension BoardDetailViewController : DiffableDataSource, UICollectionViewDelegate {
    func configureDataSource() {
        let cellRegistration = baseView.boardDetailCellRegistration()
        datasource = UICollectionViewDiffableDataSource(collectionView: baseView.commentCollectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            
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
