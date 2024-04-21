//
//  CategorySelectViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/22/24.
//

import UIKit

final class CategorySelectViewController: BaseViewController {

    final let mainView = CategorySelectView()
    var sendData : ((Category) -> Void)?
    private var dataSource : UICollectionViewDiffableDataSource<CategorySection, Category>!
    
    override func loadView() {
        view = mainView
        mainView.mainCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        updateSnapshot(Category.allCases)
    }
    
    private func configureDataSource() {
        
        let cellRegistration = mainView.periodSelectCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [Category]) {
        var snapshot = NSDiffableDataSourceSnapshot<CategorySection, Category>()
        snapshot.appendSections(CategorySection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        
        print(#function, "PeriodSelectViewController UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        
        navigationItem.title = "🔆 분야 선택하기"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    deinit {
        print(#function, " - ✅ CategorySelectViewController")
    }
}


extension CategorySelectViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectItem = dataSource.itemIdentifier(for: indexPath) else { return }
        sendData?(selectItem)
        dismiss(animated: true)
    }
}
