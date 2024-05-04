//
//  FollowTabmanViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/5/24.
//

import UIKit
import Tabman
import Pageboy

final class FollowTabmanViewController: TabmanViewController, TMBarDataSource {

    var parentCoordinator : FollowCoordinator?
    private let viewControllers: Array<RxBaseViewController>
    private let category : [FollowCategory]

    init(viewControllersList : Array<RxBaseViewController>, category : [FollowCategory]){
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

}

extension FollowTabmanViewController : PageboyViewControllerDataSource {
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        TMBarItem(title: category[index].rawValue)
    }
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.white
        
        self.dataSource = self

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
        addBar(bar, dataSource: self, at: .top)
    }
}
