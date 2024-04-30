//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/30/24.
//

import UIKit
import Tabman
import Pageboy

final class BoardMainViewController: TabmanViewController, TMBarDataSource {

    var parentCoordinator : BoardCoordinator?
    private var viewControllers: Array<RxBaseViewController>

    init(viewControllersList : Array<RxBaseViewController>){
        self.viewControllers = viewControllersList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    

}

//MARK: - Tabman 관련 사항
extension BoardMainViewController : PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = index == 0 ? "전체" : "생활꿀팁"
        
        return item
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
        
        dataSource = self
        let bar = TMBar.ButtonBar()
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystem.commonColorSet.gray
            button.selectedTintColor = DesignSystem.commonColorSet.lightBlack
        }
    
        
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20 // 버튼 사이의 간격 조절
        addBar(bar, dataSource: self, at: .top)
    }
}

