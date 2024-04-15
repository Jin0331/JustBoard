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
        static let black = UIColor.pillBlack
        static let lightBlack = UIColor.pillLightBlack
        static let gray = UIColor.pillGray
        static let white = UIColor.pillWhite
    }
    
    enum buttonColorSet {
        static let black = UIColor.pillBlack
        static let yellow = UIColor.kakaoLogin
        static let clear = UIColor.clear
    }

    enum sfSymbol {
        static let sfSymbolLargeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
        static let appleLogo = UIImage(systemName: "apple.logo", withConfiguration:sfSymbolLargeConfig)
    }
}
