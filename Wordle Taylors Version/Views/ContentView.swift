//
//  ContentView.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel(songs: fetchSongs())
    @State private var wordleState: WordleState = .daily

    @ObservedObject var dailyViewModel: DailyViewModel
    @ObservedObject var practiceViewModel: PracticeViewModel
    var dailyView: DailyView
    var practiceView: PracticeView

    init() {
        let dailyViewModel = DailyViewModel()
        let practiceViewModel = PracticeViewModel()
        dailyView = DailyView(dailyViewModel: dailyViewModel)
        practiceView = PracticeView(practiceViewModel: practiceViewModel)
        self.dailyViewModel = dailyViewModel
        self.practiceViewModel = practiceViewModel
    
        dailyView.dailyViewModel.getSong(songs: viewModel.songs)
        practiceView.practiceViewModel.getSong(songs: viewModel.songs)
    }

    var body: some View {
        VStack {
            Text("Wordle (Taylor's Version)")
                .font(.headline)
            
            HStack {
                Button(action: { self.wordleState = .daily }) {
                    Text("Daily")
                        .foregroundColor(self.wordleState == .daily ? .white : .black)
                        .padding(10)
                        .background(self.wordleState == .daily ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }

                Button(action: { self.wordleState = .practice }) {
                    Text("Practice")
                        .foregroundColor(self.wordleState == .practice ? .white : .black)
                        .padding(10)
                        .background(self.wordleState == .practice ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
            }

            switch wordleState {
            case .daily:
                // TODO: DRY this
                if let wonGame = dailyViewModel.wonGameBool {
                    if wonGame == true {
                        Text("Winner yay")
                            .foregroundColor(.green)
                            .bold()
                    } else if wonGame == false {
                        Text("Loser Boo, the right answer was:")
                            .foregroundColor(.red)
                            .bold()
                        Text((dailyViewModel.currentSong?.title ?? "") + " - " + (dailyViewModel.currentSong?.album ?? ""))
                            .bold()
                    }
                }
                dailyView
            case .practice:
                if let wonGame = practiceViewModel.wonGameBool {
                    if wonGame == true {
                        Text("Winner yay")
                            .foregroundColor(.green)
                            .bold()
                    } else if wonGame == false {
                        Text("Loser Boo, the right answer was:")
                            .foregroundColor(.red)
                            .bold()
                        Text((practiceViewModel.currentSong?.title ?? "") + " - " + (practiceViewModel.currentSong?.album ?? ""))
                            .bold()
                    }
                    Button(action: { practiceViewModel.getSong(songs: viewModel.songs) }) {
                        Text("Start New Game +")
                    }
                }
                practiceView
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Album")
                    Picker(selection: $viewModel.selectedAlbum, label: Text("Select an album")) {
                        ForEach(viewModel.albums, id: \.self) { state in
                            Text(state)
                        }
                    }
                }
                HStack {
                    Text("Song")
                    Picker(selection: $viewModel.selectedSong, label: Text("Select a song")) {
                        ForEach(viewModel.songAndAlbumDict[viewModel.selectedAlbum] ?? [], id: \.self) { city in
                            Text(city)
                        }
                    }
                }
            }

            // Button to submit the guess
            Button(action: {
                switch wordleState {
                case .daily:
                    dailyViewModel.submitGuess(selectedSong: viewModel.selectedSong, selectedAlbum: viewModel.selectedAlbum)
                case .practice:
                    practiceViewModel.submitGuess(selectedSong: viewModel.selectedSong, selectedAlbum: viewModel.selectedAlbum)
                }
            } ) {
                Text("Submit")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
