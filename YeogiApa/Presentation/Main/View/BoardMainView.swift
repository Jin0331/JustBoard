//
//  BoardMainView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import Then
import SnapKit

final class BoardMainView: BaseView {

    let questionButton = CompleteButton(title: "작성하기", image: DesignSystem.sfSymbol.question, fontSize: 15)
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.white
        view.allowsMultipleSelection = true
        
       return view
    }()
    
    typealias BoardCellRegistration = UICollectionView.CellRegistration<BoardCollectionViewCell, PostResponse>
    
    override func configureHierarchy() {
        addSubview(mainCollectionView)
        addSubview(questionButton)
    }
    
    override func configureLayout() {
        questionButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.width.equalTo(110)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    func boardCellRegistration() -> BoardCellRegistration  {
        
        return BoardCellRegistration { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
}
