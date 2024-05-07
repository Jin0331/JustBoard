//
//  Notification.Name+Extension.swift
//  JustBoard
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation

extension Notification.Name {
    static let resetLogin = Notification.Name(rawValue: "resetLogin")
    static let resetAlert = Notification.Name(rawValue: "resetAlert")
    static let boardRefresh = Notification.Name(rawValue: "boardRefresh")
    static let followRefresh = Notification.Name(rawValue: "followRefresh")
    static let goToMain = Notification.Name(rawValue: "goToMain")
    static let goToBoard = Notification.Name(rawValue: "goToBoard")
    static let goToProfile = Notification.Name(rawValue: "goToProfile")
}
