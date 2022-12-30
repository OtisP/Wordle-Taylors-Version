//
//  Wordle+Date.swift
//  Wordle Taylors Version
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

}
