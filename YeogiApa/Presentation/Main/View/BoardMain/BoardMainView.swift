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
    
    let containerView = UIView().then {
        $0.backgroundColor = .red
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.white
        view.allowsMultipleSelection = true
        view.isPagingEnabled = true
        view.register(cellType: BoardRankCollectionViewCell.self)
        
       return view
    }()
        
    override func configureHierarchy() {
        addSubview(mainCollectionView)
        addSubview(containerView)
        containerView.addSubview(tabmanViewController.view)
    }
    
    override func configureLayout() {
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        tabmanViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
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
