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
        $0.backgroundColor = DesignSystem.commonColorSet.red
    }
    
//    let containerView = UIView()
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.white
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.register(cellType: BoardRankCollectionViewCell.self)
        
       return view
    }()
        
    override func configureHierarchy() {
        
        [scrollView].forEach { addSubview($0) }
        scrollView.addSubview(contentsView)
        
        [mainCollectionView, tabmanViewController.view].forEach { contentsView.addSubview($0)}
//        containerView.addSubview(tabmanViewController.view)
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
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        tabmanViewController.view.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(mainCollectionView)
            make.height.equalTo(1000)
            make.bottom.equalToSuperview().inset(50)
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
