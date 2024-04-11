//
//  ViewModelType.swift
//  LSLPBasic
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    var disposeBag : DisposeBag { get }
    associatedtype Input
    associatedtype Output
    func transform(input : Input) -> Output
}
