//
//  Song.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import Foundation
import CSwiftV

struct Song {
    let title: String
    let album: String
    let lyrics: [String]

    var displayLyrics: [SongLyricDisplay] {
        let startIndex = Int.random(in: 0..<lyrics.count - 6)
        let splicedLyrics = Array(lyrics[startIndex ..< startIndex + 6])
        var displayLyrics: [SongLyricDisplay] = []
        
        for (index, lyric) in splicedLyrics.enumerated() {
            displayLyrics.append(SongLyricDisplay(lyric: lyric, index: index, isShown: false))
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

class SongLyricDisplay: Identifiable {
    let lyric: String
    let index: Int
    var isShown: Bool

    var isNotShown: Bool {
        return !isShown
    }

    init(lyric: String, index: Int, isShown: Bool) {
        self.lyric = lyric
        self.index = index
        self.isShown = isShown
    }

    var lyricLen: Int {
        return lyric.count
    }

    var hiddenLyric: String {
        var result = ""
        for character in lyric {
            if character.isLetter {
                result += "-"
            } else {
                result += String(character)
            }
        }
        return result
    }

    func flipShownProperty() {
        isShown = !isShown
    }
}

func fetchSongs() -> [Song] {
    // locate the file you want to use
    guard let filepath = Bundle.main.path(forResource: "songs", ofType: "csv") else {
        return []
    }

    // convert that file into one long string
    var data = ""
    do {
        data = try String(contentsOfFile: filepath)
    } catch {
        print(error)
        return []
    }

    let csv = CSwiftV.init(with: data)
    return csv.rows.map { Song(title: $0[0], album: $0[1], lyrics: $0[2]) }
}
