//
//  Formatter+Extension.swift
//  CoinMarket
//
//  Created by JinwooLee on 3/17/24.
//

import Foundation

extension String {
    func toDate(dateFormat format : String) -> Date? { //"yyyy-MM-dd HH:mm:ss Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func formatDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: self) {
            let today = Date()
            let calendar = Calendar.current
            
            if calendar.isDateInToday(date) {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "yy.MM.dd HH:mm"
            }
            
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}
