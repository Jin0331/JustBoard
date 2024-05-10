//
//  MenuViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/3/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

protocol MenuViewControllerDelegate {
    func sendProfileViewController(userID : String, me : Bool)
}

final class MenuViewController: BaseViewController {
    
    private var datasource : MenuDataSource!
    var sendDelegate : MenuViewControllerDelegate?
    
    private let headerTitle = UILabel().then {
        $0.font = DesignSystem.mainFont.TitleMedium
        $0.backgroundColor = .clear
        $0.text = "자게? 아니 자게!"
        $0.textColor = DesignSystem.commonColorSet.white
        $0.textAlignment = .center
    }
    
    lazy var menuCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.commonColorSet.lightBlack
        view.allowsMultipleSelection = false
        view.isScrollEnabled = false
        
       return view
    }()
    
    private let logoutButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(DesignSystem.commonColorSet.red, for: .normal)
        $0.titleLabel?.font = DesignSystem.mainFont.customFontHeavy(size: 18)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        updateSnapshot(MenuCase.allCases)
        menuCollectionView.delegate = self
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        logoutButton.addTarget(self, action: #selector(resetLogined), for: .touchUpInside)
    }
    
    @objc private func resetLogined() {

        showAlert2(title: "로그아웃", text: "로그아웃 하시겠습니까? 🤔", addButtonText1: "네", addButtonText2: "아뇨") { [weak self] in
            guard let self = self else { return }
            UserDefaultManager.shared.isLogined = false
            NotificationCenter.default.post(name: .resetLogin, object: nil)
            dismiss(animated: true)
        }
    }
    
    override func configureHierarchy() {
        [headerTitle, menuCollectionView, logoutButton].forEach { view.addSubview($0)}
    }
    
    override func configureLayout() {
        
        headerTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        menuCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(menuCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.lightBlack
    }
}

//MARK: - Collection View 관련
extension MenuViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    private func menuCellRegistration() -> MenuCellRegistration  {
        
        return MenuCellRegistration { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = menuCellRegistration()
        datasource = UICollectionViewDiffableDataSource(collectionView: menuCollectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.updateUI(itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [MenuCase]) {
        
        var snapshot = MenuDataSourceSnapshot()
        snapshot.appendSections(MenuViewSection.allCases)
        
        let uniqueItemsToAdd = data.filter { !snapshot.itemIdentifiers.contains($0) }
        snapshot.appendItems(uniqueItemsToAdd, toSection: .main)
        
        datasource.apply(snapshot)
    }
}

extension MenuViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let menuCase = datasource.itemIdentifier(for: indexPath) else { return }
        
        switch menuCase {
        case .myProfile:
            sendDelegate?.sendProfileViewController(userID: UserDefaultManager.shared.userId!,
                                                    me: true)
            dismiss(animated: true)
        case .home:
            NotificationCenter.default.post(name: .goToMain, object: nil)
            dismiss(animated: true)
        case .board:
            NotificationCenter.default.post(name: .goToBoard, object: nil)
            dismiss(animated: true)
        default:
            dismiss(animated: true)
        }
    }
}
