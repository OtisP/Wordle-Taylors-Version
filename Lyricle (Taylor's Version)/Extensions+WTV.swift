//
//  Lyricle+Date.swift
//  Lyricle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//
import Foundation

extension Date {
    // get the current day as integer. Divide by 86400 to forget about seconds
    var daysSince1970: Int {
        return Int(self.timeIntervalSince1970 / 86400)
    }

    var customDateInt: Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)

        let customInt = String(day) + String(month) + String(year)
        guard let int = Int(customInt) else { return 0 }
        return int
    }
    
    static var secondsTilMidnight: Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: currentDate) + 86400
        return Int(midnight.timeIntervalSince(currentDate))
    }

}

extension Int {
    var secondsToTimeDisplay: String {
        let hour = Int(self) / 3600
        let minute = Int(self) / 60 % 60
        let second = Int(self) % 60

        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
}

extension String {
    func before(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let before = prefix(upTo: index)
            return String(before)
        }
        return self
    }
}
