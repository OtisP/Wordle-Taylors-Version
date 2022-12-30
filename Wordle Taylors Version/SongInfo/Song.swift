//
//  Song.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import Foundation
import CSwiftV

struct Song: Codable, Hashable {
    let title: String
    let album: String
    let lyrics: [String]

    var displayLyrics: [SongLyricDisplay] {
        srand48(Date().daysSince1970)
        let startIndex = Int(floor((drand48() * Double(lyrics.count - 6))))
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

func fetchSongs() -> [Song] {
    // locate the file to use
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
    // TODO: data needs serious cleaning
    return csv.rows.map { Song(title: $0[0], album: $0[1], lyrics: $0[2]) }
}
