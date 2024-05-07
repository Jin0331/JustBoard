//
//  Reactive+Extension.swift
//  JustBoard
//
//  Created by JinwooLee on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
            self.modelSelected(modelType),
            self.itemSelected
        ))
    }
}
