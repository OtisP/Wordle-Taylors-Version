//
//  PracticeViewModel.swift
//  Wordle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import Foundation
import SwiftUI

class PracticeViewModel: WordleViewModelProtocol, ObservableObject {
    @Published var currentSong: Song?
    @Published var songLyricsDisplayArray: [SongLyricDisplay] = []
    @Published var lyricColors: [Color] = Array(repeating: Color.gray, count: 6)
    @Published var guessIndex: Int = 0
    
    @Published var wonGameBool: Bool? = nil

    func getSong(songs: [Song]) {
        currentSong = songs.randomElement()
        print(currentSong?.title ?? "")
        guard let songLyricsDisplayArray = currentSong?.displayLyrics else { return }
        self.songLyricsDisplayArray = songLyricsDisplayArray
        guessIndex = 0
        wonGameBool = nil
        lyricColors = Array(repeating: Color.gray, count: 6)
        
        revealSongLyric()
    }
    
    func wonGame() {
        wonGameBool = true
    }
    
    func lostGame() {
        wonGameBool = false
    }
}
