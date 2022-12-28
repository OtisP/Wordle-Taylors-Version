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

    func getSong(songs: [Song]) {
        currentSong = songs.randomElement()
        print(currentSong?.title ?? "")
        guard let songLyricsDisplayArray = currentSong?.displayLyrics else { return }
        self.songLyricsDisplayArray = songLyricsDisplayArray
        guessIndex = 0
        lyricColors = Array(repeating: Color.gray, count: 6)
        
        revealSongLyric()
    }
    
    func correctGuessed() {
        // TODO: wait a few seconds then get a new song
        print("yay")
    }
    
    func lostGame() {
        // TODO: Show right answer and then get a new song
        print("boo")
    }
}
