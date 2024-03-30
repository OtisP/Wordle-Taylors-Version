//
//  DailyContentViewModel.swift
//  Swiftical
//
//  Created by Otis Peterson on 12/28/22.
//

import Foundation
import SwiftUI

final class DailyViewModel: LyricleViewModelProtocol, Codable, ObservableObject {
    @Published var currentSong: Song?
    @Published var songLyricsDisplayArray: [SongLyricDisplay] = []
    @Published var guessResults: [GuessStatus] = Array(repeating: .notGuessed, count: 6)
    @Published var guessIndex: Int = 0
    @Published var wonGameBool: Bool?
    @Published var showCopiedOverlay: Bool = false

    // Countdown timer
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @Published var timerCount = 0
    @Published var secondsTilMidnight: Int?

    init() { }

    
    func loadTodaysSong(songs: [Song]) {
        let currentDaySong = todaysSong(songs: songs)
        if currentSong != currentDaySong {
            currentSong = currentDaySong
            guard let songLyricsDisplayArray = currentSong?.getdisplayLyrics(isSeeded: true) else { return }
            self.songLyricsDisplayArray = songLyricsDisplayArray
            guessIndex = 0
            wonGameBool = nil
            guessResults = Array(repeating: .notGuessed, count: 6)
            
            revealSongLyric()
        }
    }
    
    // Get todays song
    func todaysSong(songs: [Song]) -> Song {
        // Get the current date and use it to seed the random number generator
        // seeding turned out to be messier than I wanted here
        srand48(Date().customDateInt)
        let index = Int(floor((drand48() * Double(songs.count))))
        let currentDaySong = songs[index]
        print(currentDaySong.title)
        return currentDaySong
    }
    
    func copyShareResults() {
        withAnimation {
            showCopiedOverlay.toggle()
        }

        guard gameOver else { return }
        // title of game
        var shareText = ["Swiftical"]
        
        // current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy"
        let formattedDate = dateFormatter.string(from: Date())
        shareText.append(formattedDate)
        
        // guess squares
        var squaresString: String = ""
        for guess in guessResults {
            squaresString += guess.textBox
        }
        shareText.append(squaresString)
        
        // guess count
        shareText.append("\(guessIndex)/6")
        
        UIPasteboard.general.string = shareText.joined(separator: "\n")
        
        // Schedule to hide the overlay after a delay (1 second in this case)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.showCopiedOverlay.toggle()
            }
        }
    }
    
    //TODO: These functions could eventually contain stat-keeping logic
    func wonGame() {
        wonGameBool = true
    }
    
    func lostGame() {
        wonGameBool = false
    }
    
    //MARK: Codable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentSong = try container.decodeIfPresent(Song.self, forKey: .currentSong)
        self.songLyricsDisplayArray = try container.decode([SongLyricDisplay].self, forKey: .songLyricsDisplayArray)
        self.guessResults = try container.decode([GuessStatus].self, forKey: .guessResults)
        self.guessIndex = try container.decode(Int.self, forKey: .guessIndex)
        self.wonGameBool = try container.decodeIfPresent(Bool.self, forKey: .wonGameBool)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentSong, forKey: .currentSong)
        try container.encode(songLyricsDisplayArray, forKey: .songLyricsDisplayArray)
        try container.encode(guessResults, forKey: .guessResults)
        try container.encode(guessIndex, forKey: .guessIndex)
        try container.encode(wonGameBool, forKey: .wonGameBool)
    }
    
    enum CodingKeys: CodingKey {
        case currentSong
        case songLyricsDisplayArray
        case guessResults
        case guessIndex
        case wonGameBool
    }
}
