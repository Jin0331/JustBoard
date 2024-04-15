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

//MARK: - User에서 사용되는 ViewModel 타입
protocol UserViewModelType : ViewModelType {

}

extension UserViewModelType {
    func matchesPattern(_ string : String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: string.utf16.count)
            return regex.firstMatch(in: string, options: [], range: range) != nil
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
            return false
        }
    }
    
    func isValidEmail(_ email : String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return matchesPattern(email, pattern: emailPattern)
    }
    
    // 최소 8 자 및 최대 15 자, 하나 이상의 대문자/소문자/숫자/특수문자(.@$!%*?&) 정규식
    func isValidPassword(_ password : String) -> Bool {
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\\.@$!%*?&])[A-Za-z\\d\\.@$!%*?&]{8,15}$"
        return matchesPattern(password, pattern: passwordPattern)
    }
}
