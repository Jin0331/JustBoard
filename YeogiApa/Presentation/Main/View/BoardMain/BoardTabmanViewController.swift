//
//  BoardTabmanViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxViewController
import Tabman
import Pageboy

final class BoardTabmanViewController: TabmanViewController, TMBarDataSource {
    
    let baseView = UIView()
    var parentCoordinator : BoardMainCoordinator?
    private let viewControllers: Array<RxBaseViewController>
    private let category : [BestCategory]

    init(viewControllersList : Array<RxBaseViewController>, category : [BestCategory]){
        self.viewControllers = viewControllersList
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureView()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("BoardTabmanViewController - viewWillApper✅")
    }
}

//MARK: - Tabman 관련 사항
extension BoardTabmanViewController : PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = category[index].rawValue
        
        return TMBarItem(title: title)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.white
        
        self.dataSource = self

        //MARK: - BaseView
        view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let bar = TMBar.ButtonBar()
        self.isScrollEnabled = false
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystem.commonColorSet.black
            button.selectedTintColor = DesignSystem.commonColorSet.black
            button.font = .systemFont(ofSize: 18, weight: .heavy)
        }
    
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20 // 버튼 사이의 간격 조절
        
        bar.indicator.tintColor = DesignSystem.commonColorSet.black
        bar.indicator.overscrollBehavior = .none
        
        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: baseView, layout: nil))
    }
}
