//
//  BoardMainView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/30/24.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import Reusable
import Tabman
import Pageboy

final class BoardMainView: BaseView {
    let tabmanViewController : TabmanViewController
    
    init(tabmanViewController: TabmanViewController) {
        self.tabmanViewController = tabmanViewController
        super.init(frame: .zero)
    }
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.lightGray
    }
    
    lazy var postRankCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.white
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.register(cellType: BoardRankCollectionViewCell.self)
        
       return view
    }()
    
    lazy var userRankCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.white
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.register(cellType: BoardRankCollectionViewCell.self)
        
       return view
    }()
    
    let movewToAllBoard = CompleteButton(title: "", image: nil, fontSize: 17).then {
        $0.layer.cornerRadius = 0
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    let boardRankLabel = CommonLabel(title: "실시간 게시판 Best 20", fontSize: 18)
    let boardUserRankLabel = CommonLabel(title: "실시간 유저 Best 20", fontSize: 18)
    let boardPostRankLabel = CommonLabel(title: "실시간 게시글 순위", fontSize: 18)
        
    override func configureHierarchy() {
        
        [scrollView].forEach { addSubview($0) }
        scrollView.addSubview(contentsView)
        
        [boardRankLabel, postRankCollectionView, boardUserRankLabel, userRankCollectionView, boardPostRankLabel, tabmanViewController.view, movewToAllBoard].forEach { contentsView.addSubview($0)}
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        boardRankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        postRankCollectionView.snp.makeConstraints { make in
            make.top.equalTo(boardRankLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        boardUserRankLabel.snp.makeConstraints { make in
            make.top.equalTo(postRankCollectionView.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        userRankCollectionView.snp.makeConstraints { make in
            make.top.equalTo(boardUserRankLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        boardPostRankLabel.snp.makeConstraints { make in
            make.top.equalTo(userRankCollectionView.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        tabmanViewController.view.snp.makeConstraints { make in
            make.top.equalTo(boardPostRankLabel.snp.bottom)
            make.horizontalEdges.equalTo(postRankCollectionView)
            make.height.equalTo(2300)
        }
        
        movewToAllBoard.snp.makeConstraints { make in
            make.top.equalTo(tabmanViewController.view.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(tabmanViewController.view)
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
        }
    }
}

extension BoardMainView {
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
