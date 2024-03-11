//
//  DateHelper.swift
//  Scarlet
//
//  Created by Ali Merhie on 5/20/19.
//  Copyright © 2019 Monty Mobile. All rights reserved.
//

import Foundation
extension String {
    
     func toDateUTC () -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       return dateFormatter.date(from: self ) ?? Date()
    }
    
    func toDateUTCComplete () -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm aa"
        return dateFormatter.date(from: self )!
    }
    
    func toTimeUTC () -> Date {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        return timeFormatter.date(from: "2019/01/01 " + self)!
    }
    
    func toDateFormatted() -> Date {
          let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self ?? "") ?? Date()
    }

}

extension Date {
    
    func toDateString() -> String {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        return dateStringFormatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let timeStringFormatter = DateFormatter()
        timeStringFormatter.dateFormat = "h:mm a"
        return timeStringFormatter.string(from: self)
        
    }
    func toTime24String() -> String {
        let timeStringFormatter = DateFormatter()
        timeStringFormatter.dateFormat = "hh:mm:ss"
        return timeStringFormatter.string(from: self)
        
    }
    func timeAgo() -> String {
         let formatter = DateComponentsFormatter()
         formatter.unitsStyle = .full
         formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second] //[.year, .month, .day, .hour, .minute, .second]
         formatter.zeroFormattingBehavior = .dropAll
         formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current) + " ago"
     }
    func getLast6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }
    
    func getLast3Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)
    }
    
    func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    func getLast7Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    
    func getLast30Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    // This Month Start
    func getThisMonthStart() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Month Start
    func getLastMonthStart() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }

    // Last Month End
    func getLastMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
}
