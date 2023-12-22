//
//  ContentViewModel.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI
import SQLite3

class ContentViewModel: ObservableObject {
    @Published var selectedAlbum: String {
        willSet {
            selectedSong = (songAndAlbumDict[newValue]?[0].title) ?? ""
        }
    }
    @Published var selectedSong: String
    @Published var wordleState: WordleState = .daily

    var songAndAlbumDict: [String : [Song]] = [:]
    let songs: [Song]
    var albums: [String] {
        let albumKeys = songAndAlbumDict.keys
        return albumKeys.sorted { $0.mapAlbums() < $1.mapAlbums() }
    }

    @Published var dailyViewModel: DailyViewModel
    @Published var practiceViewModel: PracticeViewModel
    var dailyView: DailyView
    var practiceView: PracticeView

    init() {
        var db: OpaquePointer?

        var songList: [Song] = []
        guard let dbPath = Bundle.main.path(forResource: "songs", ofType: "sqlite")  else {
            fatalError()
        }
        
        // Open the database
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")

            var statement: OpaquePointer?

            let query = "SELECT * FROM songs;"

            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    // Access results
                    let songTitle = String(cString: sqlite3_column_text(statement, 0))
                    let songAlbum = String(cString: sqlite3_column_text(statement, 1))
                    let songLyrics = String(cString: sqlite3_column_text(statement, 2))

                    songList.append(Song(title: songTitle, album: songAlbum, lyrics: songLyrics))
                }
            } else {
                fatalError("Error preparing SQL statement")
            }

            // Finalize the statement to release resources
            sqlite3_finalize(statement)
        } else {
            fatalError("Unable to open database.")
        }

        // Close the database connection
        sqlite3_close(db)

        self.songs = songList
        for song in self.songs {
            if songAndAlbumDict[song.album] != nil {
                songAndAlbumDict[song.album]?.append(song)
            } else {
                songAndAlbumDict[song.album] = [song]
            }
        }
        
        selectedAlbum = songs[0].album
        selectedSong = songs[0].title

        let decoder = JSONDecoder()

        // MARK: DailyView
        // If there is state saved in the DailyViewModel then load it
        var dailyViewModel: DailyViewModel
        if let savedDailyViewModel = UserDefaults.standard.object(forKey: "dailyViewModel") as? Data,
           let unwrappedDailyViewModel = try? decoder.decode(DailyViewModel.self, from: savedDailyViewModel) {
            dailyViewModel = unwrappedDailyViewModel
        } else {
            dailyViewModel = DailyViewModel()
        }
        dailyView = DailyView(dailyViewModel: dailyViewModel, songs: songs)
        self.dailyViewModel = dailyViewModel
        dailyView.dailyViewModel.loadTodaysSong(songs: songs)

        // MARK: PracticeView
        let practiceViewModel = PracticeViewModel(songs: songs)
        practiceView = PracticeView(practiceViewModel: practiceViewModel)
        self.practiceViewModel = practiceViewModel
        practiceView.practiceViewModel.loadTodaysSong(songs: songs)

        self.selectedAlbum = albums[0]
        self.selectedSong = songAndAlbumDict[selectedAlbum]?[0].title ?? ""
    }
    
    func submitGuess() {
        switch wordleState {
        case .daily:
            guard !dailyViewModel.gameOver else { return }
            dailyViewModel.submitGuess(selectedSong: selectedSong, selectedAlbum: selectedAlbum)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(dailyViewModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "dailyViewModel")
            }
        case .practice:
            guard !practiceViewModel.gameOver else { return }
            practiceViewModel.submitGuess(selectedSong: selectedSong, selectedAlbum: selectedAlbum)
        }
    }
}

private extension String {
    func mapAlbums() -> Int {
        switch self {
        case "Debut":
            return 0
        case "Fearless (TV)":
            return 1
        case "Speak Now (TV)":
            return 2
        case "Red (TV)":
            return 3
        case "1989 (TV)":
            return 4
        case "Reputation":
            return 5
        case "Lover":
            return 6
        case "folklore":
            return 7
        case "evermore":
            return 8
        case "Midnights":
            return 9
        default:
            return 11
        }
    }
}
