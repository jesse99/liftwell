//  Created by Jesse Jones on 10/20/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func secsToShortDurationName(_ interval: Double) -> String {
    let secs = Int(round(interval))
    let mins = interval/60.0
    let hours = interval/3600.0
    let days = round(hours/24.0)
    
    if secs < 120 {
        return secs == 1 ? "1 sec" : "\(secs) secs"
    } else if mins < 60.0 {
        return String(format: "%0.1f mins", arguments: [mins])
    } else if hours < 24.0 {
        return String(format: "%0.1f hours", arguments: [hours])
    } else {
        return String(format: "%0.1f days", arguments: [days])
    }
}

func minsToStr(_ mins: Int) -> String {
    let interval = 60*Double(mins)
    let hours = interval/3600.0
    let days = round(hours/24.0)
    
    if mins <= 60 {
        return String(format: "%d mins", arguments: [mins])
    } else if hours < 24.0 {
        return String(format: "%0.1f hours", arguments: [hours])
    } else {
        return String(format: "%0.1f days", arguments: [days])
    }
}

extension Date {
    func minsSinceDate(_ rhs: Date) -> Double {
        let secs = self.timeIntervalSince(rhs)
        let mins = secs/60.0
        return mins
    }
    
    func hoursSinceDate(_ rhs: Date) -> Double {
        let secs = self.timeIntervalSince(rhs)
        let mins = secs/60.0
        let hours = mins/60.0
        return hours
    }
    
    func daysSinceDate(_ rhs: Date) -> Double {
        let secs = self.startOfDay().timeIntervalSince(rhs.startOfDay())
        let mins = secs/60.0
        let hours = mins/60.0
        let days = hours/24.0
        return days
    }
    
    func weeksSinceDate(_ rhs: Date) -> Double {
        // TODO: This and the above could be better done with NSDateComponents,
        // see https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
        let secs = self.startOfDay().timeIntervalSince(rhs.startOfDay())
        let mins = secs/60.0
        let hours = mins/60.0
        let days = hours/24.0
        let weeks = days/7.0
        return weeks
    }
    
    /// Returns a human readable string for something that should be of a
    /// short duration, e.g. "1 sec" or "2.4 mins".
    func shortDurationName() -> String {
        let interval = Date().timeIntervalSince(self)
        return secsToShortDurationName(interval)
    }
    
    /// Returns a human readable string for something that should be of a
    /// long duration, e.g. "3 months" or "2.4 years".
    func longDurationName() -> String {
        let secs = Date().timeIntervalSince(self)
        let mins = secs/60.0
        let hours = mins/60.0
        let days = hours/24.0
        let months = days/30.0
        let years = months/12.0
        
        if months < 1.0 {
            let n = Int(round(days))
            return n <= 1 ? "1 day" : "\(n) days"
        } else if years < 1.0 {
            let n = Int(round(months))
            return n == 1 ? "1 month" : "\(n) months"
        } else {
            return String(format: "%.1f years", arguments: [years])
        }
    }
    
    func startOfDay() -> Date {
        let calendar = Calendar.current
        let result = calendar.startOfDay(for: self)
        return result
    }
    
    /// Returns a human readable string for number of days.
    func daysName() -> String {
        let calendar = Calendar.current
        
        // This is a bit awful but I can't figure out a good way to do this
        // 1) calendar.ordinalityOfUnit(.Day, inUnit: .Era, forDate: self)
        // is close but doesn't return "the decomposed value" and doesn't
        // always work.
        // 2) timeIntervalSinceDate can be made to work but uses elapsed
        // time so odd things happen around midnight.
        // 3) components:fromDate:toDate:options: seems to work similarly to
        // timeIntervalSinceDate.
        if calendar.isDate(self, inSameDayAs: Date()) {
            return "today"
        }
        
        if let candidate = (calendar as NSCalendar).date(byAdding: .day, value: -1, to: Date(), options: .searchBackwards) , calendar.isDate(self, inSameDayAs: candidate) {
            return "yesterday"
        }
        
        for days in 2...31 {
            if let candidate = (calendar as NSCalendar).date(byAdding: .day, value: -days, to: Date(), options: .searchBackwards) , calendar.isDate(self, inSameDayAs: candidate) {
                return "\(days) days ago"
            }
        }
        
        for months in 1...12 {
            if let candidate = (calendar as NSCalendar).date(byAdding: .month, value: -months, to: Date(), options: .searchBackwards) , (calendar as NSCalendar).isDate(self, equalTo: candidate, toUnitGranularity: .month) {
                if months == 1 {
                    return "1 month ago"
                } else {
                    return "\(months) months ago"
                }
            }
        }
        
        for years in 1...10 {
            if let candidate = (calendar as NSCalendar).date(byAdding: .year, value: -years, to: Date(), options: .searchBackwards) , (calendar as NSCalendar).isDate(self, equalTo: candidate, toUnitGranularity: .year) {
                if years == 1 {
                    return "1 year ago"
                } else {
                    return "\(years) years ago"
                }
            }
        }
        
        return ">10 years ago"
    }
}

