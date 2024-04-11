//
//  ImageSystem.swift
//  CoinMarket
//
//  Created by JinwooLee on 2/27/24.
//

import UIKit

enum DesignSystem {
    
    enum imageByGY {
        static let empty = UIImage(named: "Empty")
        static let empty1 = UIImage(named: "Empty1")
        static let empty2 = UIImage(named: "Empty2")
        static let pillIcon = UIImage(named: "pillIcon")
        static let kfda = UIImage(named: "kfda")
        static let camera = UIImage(named: "camera")
        static let web = UIImage(named: "web")
        static let check = UIImage(named: "check")
        static let checkFalse = UIImage(named: "check_remove")
    }
    
    enum colorSet  {
        static let black = UIColor.pillBlack
        static let lightBlack = UIColor.pillLightBlack
        static let gray = UIColor.pillGray
        static let lightGray = UIColor.pillLightGray
        static let red = UIColor.pillRed
        static let white = UIColor.pillWhite
        static let purple = UIColor.pillpurple
    }

    enum sfSymbol {
        static let sfSymbolLargeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
        static let sfSymbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .heavy, scale: .large)
        static let clear = UIImage(named: "clear")?.withRenderingMode(.alwaysOriginal)
        static let today = UIImage(systemName: "location.circle", withConfiguration: sfSymbolLargeConfig)
        static let info = UIImage(systemName: "info.circle", withConfiguration: sfSymbolConfig)
        static let search = UIImage(systemName: "magnifyingglass")
        static let cancel = UIImage(systemName: "x.circle", withConfiguration:sfSymbolLargeConfig)
        static let alarm = UIImage(systemName: "alarm", withConfiguration: sfSymbolLargeConfig)
        static let trash = UIImage(systemName: "trash", withConfiguration: sfSymbolLargeConfig)
        static let startDate = UIImage(systemName: "calendar.badge.plus",withConfiguration:sfSymbolLargeConfig)
        
        static let plus = UIImage(systemName: "plus", withConfiguration:sfSymbolLargeConfig)
    }
    
    enum iconURL {
        static let defaultPill = URL(string:"https://cdn-icons-png.flaticon.com/512/8889/8889618.png")
    }
    
    enum viewLayout {
        static let borderWidth = 1.5
        static let cornerRadius = 6.0
        static let imageCornetRadius = 8.0
    }
    
    enum tabbarImage {
        static let sfSymbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy, scale: .large)
        static let pillList = UIImage(systemName: "pills.fill", withConfiguration: sfSymbolConfig)
        static let calendar = UIImage(systemName: "calendar", withConfiguration: sfSymbolConfig)
    }
    
    enum swipeColor {
        static let more = #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        static let edit = #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        static let trash = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
    }
    
    enum pillManagementSwipeImage {
        static let sfSymbolLargeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        static let more = UIImage(systemName: "info.circle", withConfiguration: sfSymbolLargeConfig)
        static let edit = UIImage(systemName: "square.and.pencil", withConfiguration: sfSymbolLargeConfig)
        static let trash = UIImage(systemName: "trash", withConfiguration: sfSymbolLargeConfig)
    }
    
    enum pillAlarmSwipeImage {
        static let sfSymbolLargeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        static let trash = UIImage(systemName: "trash", withConfiguration: sfSymbolLargeConfig)
        static let edit = UIImage(systemName: "square.and.pencil", withConfiguration: sfSymbolLargeConfig)
    }
}
