//
//  Song.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import Foundation

struct Song: Codable, Hashable {
    let title: String
    let album: String
    let lyrics: [String]

    func getdisplayLyrics(isSeeded: Bool) -> [SongLyricDisplay] {
        var isValidLyrics = false
        if isSeeded {
            srand48(Date().daysSince1970)
        }
        var displayLyrics: [SongLyricDisplay] = []
        while !isValidLyrics {
            isValidLyrics = true
            displayLyrics = []
            let startIndex = Int(floor((drand48() * Double(lyrics.count - 6))))
            let splicedLyrics = Array(lyrics[startIndex ..< startIndex + 6])
            
            for (index, lyric) in splicedLyrics.enumerated() {
                if lyric.before(first: "(").lowercased().contains(self.title.lowercased()) {
                    isValidLyrics = false
                }
                displayLyrics.append(SongLyricDisplay(lyric: lyric, index: index, isShown: false))
            }
        }
        return displayLyrics
    }

    init(title: String, album: String, lyrics: String) {
        self.title = title
        self.album = album
        let splitLyrics = lyrics.components(separatedBy: "\n")
        let filteredLyrics = splitLyrics.filter { !$0.isEmpty && $0.first != "[" }
        self.lyrics = filteredLyrics
    }

}

class SongLyricDisplay: Codable, Identifiable {
    let lyric: String
    let index: Int
    var isShown: Bool

    var isNotShown: Bool {
        return !isShown
    }

    var lyricLen: Int {
        return lyric.count
    }

    init(lyric: String, index: Int, isShown: Bool) {
        self.lyric = lyric
        self.index = index
        self.isShown = isShown
    }

    func flipShownProperty() {
        isShown = !isShown
    }
}
