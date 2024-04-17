//
//  UserDefaultManager.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import Foundation

//MARK: - Token 관리를 위한 UserDefaultManager
@propertyWrapper
struct UserStatus {
    private let key: String
 
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: String? {
        get { UserDefaults.standard.string(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

@propertyWrapper
struct UserLogin {
    private let key: String
 
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: Bool {
        get { UserDefaults.standard.bool(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
 
final class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    private let userDefaults = UserDefaults.standard
    
    private init () { }
    
    // PropertyWrapper 적용
    @UserStatus(key: "accessToken") var accessToken : String?
    @UserStatus(key: "refreshToken") var refreshToken : String?
    @UserStatus(key: "user_id") var userId : String?
    @UserStatus(key: "email") var email : String?
    @UserStatus(key: "nick") var nick : String?
    @UserLogin(key: "userLogin") var isLogined : Bool
    
    func removeData(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func clearAllData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
    }
}
