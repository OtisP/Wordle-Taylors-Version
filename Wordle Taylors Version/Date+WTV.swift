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
}
