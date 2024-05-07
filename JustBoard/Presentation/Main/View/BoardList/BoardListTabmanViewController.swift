//
//  BoardListTabmanViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import Tabman
import Pageboy

final class BoardListTabmanViewController: TabmanViewController, TMBarDataSource {

    var parentCoordinator : BoardListCoordinator?
    private let viewControllers: Array<RxBaseViewController>
    private let category : [BoardListCategory]
    
    
    init(viewControllersList : Array<RxBaseViewController>, category : [BoardListCategory]){
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
        configureNavigation(title: "게시판 목록")
    }
    
    private func configureNavigation(title : String) {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = DesignSystem.commonColorSet.lightBlack
        navigationItem.backBarButtonItem = backBarButtonItem
        
        navigationItem.title = title
    }
}

extension BoardListTabmanViewController : PageboyViewControllerDataSource {
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
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystem.commonColorSet.black
            button.selectedTintColor = DesignSystem.commonColorSet.black
            button.font = .systemFont(ofSize: 18, weight: .heavy)
        }
    
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        
        bar.indicator.tintColor = DesignSystem.commonColorSet.black
        bar.indicator.overscrollBehavior = .none
//
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
}
