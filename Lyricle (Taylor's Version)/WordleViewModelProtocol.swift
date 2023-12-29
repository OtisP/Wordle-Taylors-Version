//
//  LyricleViewModel.swift
//  Lyricle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import Foundation
import SwiftUI

enum LyricleState {
    case daily
    case practice
}

// What every lyric display viewModel should have the ability to do
protocol LyricleViewModelProtocol: AnyObject, ObservableObject {
    var currentSong: Song? { get set }
    var songLyricsDisplayArray: [SongLyricDisplay] { get set }
    var guessResults: [GuessStatus] { get set }
    var guessIndex: Int { get set }
    var wonGameBool: Bool? { get set }
    
    var gameOver: Bool { get }
    var lyricColors: [Color] { get }

    /// The way that songs are gotten at the start/for a new game
    func loadTodaysSong(songs: [Song])
    func submitGuess(selectedSong: String, selectedAlbum: String)
    func revealSongLyric()
    func updateColor(_ guessidx: Int, selectedSong: String, selectedAlbum: String)
    func wonGame()
    func lostGame()
}

extension LyricleViewModelProtocol {
    var lyricColors: [Color] {
        guessResults.map { $0.color }
    }
    
    var gameOver: Bool {
        return wonGameBool != nil
    }

    func submitGuess(selectedSong: String, selectedAlbum: String) {
        // update the color
        updateColor(guessIndex - 1, selectedSong: selectedSong, selectedAlbum: selectedAlbum)
        // Check if the guess is correct
        if selectedSong.lowercased() == currentSong?.title.lowercased() {
            wonGame()
        } else {
            // Incorrect guess should reveal a lyric
            revealSongLyric()
        }
    }

    func revealSongLyric() {
        // End the game if they are out of guesses
        if guessIndex >= songLyricsDisplayArray.count {
            lostGame()
            return
        }
        songLyricsDisplayArray[guessIndex].flipShownProperty()
        guessIndex += 1
    }

    func updateColor(_ guessidx: Int, selectedSong: String, selectedAlbum: String) {
        if selectedAlbum == currentSong?.album && selectedSong == currentSong?.title {
            guessResults[guessidx] = .correctSong
        } else if selectedAlbum == currentSong?.album {
            guessResults[guessidx] = .incorrectSong
        } else {
            guessResults[guessidx] = .incorrectAlbum
        }
    }
    

}

