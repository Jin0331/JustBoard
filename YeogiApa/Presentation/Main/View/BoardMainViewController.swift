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
    private let viewControllers: Array<RxBaseViewController>
    private let category : [Category]

    init(viewControllersList : Array<RxBaseViewController>, category : [Category]){
        self.viewControllers = viewControllersList
        self.category = category
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

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize

        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
}

