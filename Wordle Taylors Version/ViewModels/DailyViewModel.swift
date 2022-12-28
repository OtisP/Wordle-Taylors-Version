//
//  DailyContentViewModel.swift
//  Wordle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import Foundation
import SwiftUI

class DailyViewModel: WordleViewModelProtocol, ObservableObject {
    @Published var currentSong: Song?
    @Published var songLyricsDisplayArray: [SongLyricDisplay] = []
    @Published var lyricColors: [Color] = Array(repeating: Color.gray, count: 6)
    @Published var guessIndex: Int = 0
    @Published var wonGameBool: Bool?

    func getSong(songs: [Song]) {
        // Get the current date and use it to seed the random number generator
        // seeding turned out to be messier than I wanted here
        srand48(Date().daysSince1970)
        let index = Int(floor((drand48() * Double(songs.count))))
        currentSong = songs[index]
        print(currentSong?.title ?? "")
        
        guard let songLyricsDisplayArray = currentSong?.displayLyrics else { return }
        self.songLyricsDisplayArray = songLyricsDisplayArray
        guessIndex = 0
        wonGameBool = nil
        lyricColors = Array(repeating: Color.gray, count: 6)
        
        revealSongLyric()
    }
    
    func wonGame() {
        // TODO
        wonGameBool = true
        print("yay")
    }
    
    func lostGame() {
        // TODO
        wonGameBool = false
        print("boo")
    }
}
