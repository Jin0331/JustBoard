//
//  BoardRankView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/13/24.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import Reusable

final class BoardRankView: BaseView {
    
    lazy var rankCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.white
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.register(cellType: BoardRankCollectionViewCell.self)
        
        return view
    }()
    
    override func configureHierarchy() {
        backgroundColor = .red
        addSubview(rankCollectionView)
    }
    
    override func configureLayout() {
        
        rankCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.bottom.horizontalEdges.equalToSuperview()
            
        }
    }
}

extension BoardRankView {
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
