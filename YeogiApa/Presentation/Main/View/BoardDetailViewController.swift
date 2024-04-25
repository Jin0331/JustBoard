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

        
        let input = BoardDetailViewModel.Input(
            viewWillAppear: rx.viewDidAppear,
            commentText: mainView.commentTextField.rx.text.orEmpty,
            commentComplete: mainView.commentCompleteButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .drive(with: self) { owner, value in
                
            }
            .disposed(by: disposeBag)
        
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
            .debug("updatedPost")
            .bind(with: self) { owner, postData in
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
        snapshot.appendItems(data, toSection: .main)
        
        datasource.apply(snapshot)
    }
}
