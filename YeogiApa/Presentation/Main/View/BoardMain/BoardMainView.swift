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
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.white
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.register(cellType: BoardRankCollectionViewCell.self)
        
       return view
    }()
    
    let movewToAllBoard = CompleteButton(title: "전체 실시간 게시판으로 이동 >", image: nil, fontSize: 17).then {
        $0.layer.cornerRadius = 0
    }
    
    let boardRankLabel = CommonLabel(title: "실시간 게시판 순위", fontSize: 18)
    let boardPostRankLabel = CommonLabel(title: "실시간 게시글 순위", fontSize: 18)
        
    override func configureHierarchy() {
        
        [scrollView].forEach { addSubview($0) }
        scrollView.addSubview(contentsView)
        
        [boardRankLabel, mainCollectionView, boardPostRankLabel, tabmanViewController.view, movewToAllBoard].forEach { contentsView.addSubview($0)}
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
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(boardRankLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        boardPostRankLabel.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        tabmanViewController.view.snp.makeConstraints { make in
            make.top.equalTo(boardPostRankLabel.snp.bottom)
            make.horizontalEdges.equalTo(mainCollectionView)
            make.height.equalTo(2200)
        }
        
        movewToAllBoard.snp.makeConstraints { make in
            make.top.equalTo(tabmanViewController.view.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(tabmanViewController.view)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

extension BoardMainView {
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
