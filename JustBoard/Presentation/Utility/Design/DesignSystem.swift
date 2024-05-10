//
//  ImageSystem.swift
//  CoinMarket
//
//  Created by JinwooLee on 2/27/24.
//

import UIKit

enum DesignSystem {
    enum cornerRadius {
        static let commonCornerRadius = 7.0
    }

    enum commonColorSet  {
        static let red = UIColor.red
        static let black = UIColor.pillBlack
        static let lightBlack = UIColor.pillLightBlack
        static let gray = UIColor.pillGray
        static let lightGray = UIColor.pillLightGray
        static let white = UIColor.pillWhite
    }
    
    enum buttonColorSet {
        static let black = UIColor.pillBlack
        static let yellow = UIColor.kakaoLogin
        static let clear = UIColor.clear
    }

    enum sfSymbol {
        static let sfSymbolSmallConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        static let sfSymbolLargeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
        static let sfSymbolLargeConfig2 = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy, scale: .large)
        
        static let appleLogo = UIImage(systemName: "apple.logo", withConfiguration:sfSymbolLargeConfig)
        static let question = UIImage(systemName: "square.and.pencil", withConfiguration:sfSymbolLargeConfig2)
        static let photo = UIImage(systemName: "photo", withConfiguration:sfSymbolLargeConfig)
        static let like = UIImage(systemName: "hand.thumbsup", withConfiguration:sfSymbolLargeConfig2)
        static let comment = UIImage(systemName: "bubble", withConfiguration:sfSymbolLargeConfig2)
        static let link = UIImage(systemName: "link.badge.plus", withConfiguration:sfSymbolLargeConfig)
        
        // Menu
        static let list = UIImage(systemName: "list.dash", withConfiguration:sfSymbolLargeConfig)
        static let home = UIImage(systemName: "house", withConfiguration:sfSymbolSmallConfig)
        static let profile = UIImage(systemName: "person.crop.circle", withConfiguration:sfSymbolSmallConfig)
        static let latest = UIImage(systemName: "clock.arrow.circlepath", withConfiguration:sfSymbolSmallConfig)
        
        static let doc = UIImage(systemName: "chart.bar.doc.horizontal", withConfiguration:sfSymbolLargeConfig)
        
        static let camera = UIImage(systemName: "camera.metering.partial", withConfiguration:sfSymbolLargeConfig2)
    
    }
    
    enum tabbarImage {
        static let sfSymbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy, scale: .large)
        static let first = UIImage(systemName: "house", withConfiguration: sfSymbolConfig)
        static let second = UIImage(systemName: "person.fill", withConfiguration: sfSymbolConfig)
    }
    
    enum defaultimage {
        static let defaultProfile = "uploads/posts/defaultProfile@3x_1714675687120.jpg"
        static let defaultProfileWithURl = URL(string:APIKey.baseURLWithVersion() + "/" + defaultProfile)!
    }
    
    enum mainFont {
//        static let large = UIFont(name: "YANGJIN", size: 25)
//        static let medium = UIFont(name: "YANGJIN", size: 22)
        static let TitleLarge = UIFont(name: "Pretendard-Black", size: 25)
        static let TitleMedium = UIFont(name: "Pretendard-Black", size: 22)
        
        static func customFontHeavy(size : CGFloat) -> UIFont {
            return UIFont(name: "Pretendard-Black", size: size)!
        }
        
        static func customFontBold(size : CGFloat) -> UIFont {
            return UIFont(name: "Pretendard-ExtraBold", size: size)!
        }
        
        static func customFontSemiBold(size : CGFloat) -> UIFont {
            return UIFont(name: "Pretendard-SemiBold", size: size)!
        }

        
        static func customFontMedium(size : CGFloat) -> UIFont {
            return UIFont(name: "Pretendard-Medium", size: size)!
        }
    }
}
