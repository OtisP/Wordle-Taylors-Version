//
//  PracticeViewModel.swift
//  Lyricle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import Foundation
import SwiftUI

class PracticeViewModel: LyricleViewModelProtocol, ObservableObject {
    
    @Published var currentSong: Song?
    @Published var songLyricsDisplayArray: [SongLyricDisplay] = []
    @Published var guessResults: [GuessStatus] = Array(repeating: .notGuessed, count: 6)
    @Published var guessIndex: Int = 0

    @Published var wonGameBool: Bool? = nil
    let songs: [Song]

    init(songs: [Song]) {
        self.songs = songs
    }

    func loadTodaysSong(songs: [Song]) {
        currentSong = songs.randomElement()
        print(currentSong?.title ?? "")
        guard let songLyricsDisplayArray = currentSong?.getdisplayLyrics(isSeeded: false) else { return }
        self.songLyricsDisplayArray = songLyricsDisplayArray
        guessIndex = 0
        wonGameBool = nil
        guessResults = Array(repeating: .notGuessed, count: 6)
        
        revealSongLyric()
    }

    func wonGame() {
        wonGameBool = true
    }

    func lostGame() {
        wonGameBool = false
    }
}
