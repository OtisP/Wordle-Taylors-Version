//
//  GuessResult.swift
//  Lyricle Taylors Version
//
//  Created by Otis Peterson on 12/22/23.
//

import SwiftUI

enum GuessStatus: Codable {
    case incorrectAlbum
    case incorrectSong
    case correctSong
    case notGuessed
    
    var color: Color {
        switch self {
        case .incorrectAlbum:
            Color(red: 255.0/255.0, green: 71.0/255.0, blue: 71.0/255.0) // red
        case .incorrectSong:
            Color(red: 255.0/255.0, green: 164.0/255.0, blue: 80.0/255.0) // orange
        case .correctSong:
            Color(red: 126.0/255.0, green: 198.0/255.0, blue: 74.0/255.0) // green
            // rgb(59,195,122)
        case .notGuessed:
            Color.gray
        }
    }
    
    var textBox: String {
        switch self {
        case .incorrectAlbum:
            "🟥"
        case .incorrectSong:
            "🟧"
        case .correctSong:
            "🟩"
        case .notGuessed:
            ""
        }
    }
}
