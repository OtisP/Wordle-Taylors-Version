//
//  ContentViewModel.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI
import CSwiftV

class ContentViewModel: ObservableObject {
    @Published var selectedAlbum = ""
    @Published var selectedSong = ""
    @Published var wordleState: WordleState = .daily
    
    var songAndAlbumDict: [String : [String]] = [:]
    let songs: [Song]
    var albums: [String] {
        let albumKeys = songAndAlbumDict.keys
        return albumKeys.sorted { $0 < $1 }
    }

    @Published var dailyViewModel: DailyViewModel
    @Published var practiceViewModel: PracticeViewModel
    var dailyView: DailyView
    var practiceView: PracticeView

    init(songs: [Song]) {
        self.songs = songs
        for song in self.songs {
            if songAndAlbumDict[song.album] != nil {
                songAndAlbumDict[song.album]?.append(song.title)
            } else {
                songAndAlbumDict[song.album] = [song.title]
            }
        }

        // MARK: DailyView
        // If there is state saved in the DailyViewModel then load it
        var dailyViewModel: DailyViewModel
        let decoder = JSONDecoder()
        if let savedDailyViewModel = UserDefaults.standard.object(forKey: "dailyViewModel") as? Data,
           let unwrappedDailyViewModel = try? decoder.decode(DailyViewModel.self, from: savedDailyViewModel) {
            dailyViewModel = unwrappedDailyViewModel
        } else {
            dailyViewModel = DailyViewModel()
        }
        dailyView = DailyView(dailyViewModel: dailyViewModel)
        self.dailyViewModel = dailyViewModel
        if dailyViewModel.currentSong == nil {
            dailyView.dailyViewModel.getSong(songs: songs)
        }

        // MARK: PracticeView
        let practiceViewModel = PracticeViewModel(songs: songs)
        practiceView = PracticeView(practiceViewModel: practiceViewModel)
        self.practiceViewModel = practiceViewModel
        practiceView.practiceViewModel.getSong(songs: songs)

        self.selectedAlbum = albums[0]
        self.selectedSong = songAndAlbumDict[selectedAlbum]?[0] ?? ""
    }
    
    func submitGuess() {
        switch wordleState {
        case .daily:
            dailyViewModel.submitGuess(selectedSong: selectedSong, selectedAlbum: selectedAlbum)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(dailyViewModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "viewModel.dailyViewModel")
            }
        case .practice:
            practiceViewModel.submitGuess(selectedSong: selectedSong, selectedAlbum: selectedAlbum)
        }
    }
}
