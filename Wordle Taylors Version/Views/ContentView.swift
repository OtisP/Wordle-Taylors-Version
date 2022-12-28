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

    var dailyView: DailyView
    var practiceView: PracticeView

    init() {
        dailyView = DailyView(dailyViewModel: DailyViewModel())
        practiceView = PracticeView(practiceViewModel: PracticeViewModel())

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
                dailyView
            case .practice:
                practiceView
            }

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

            // Button to submit the guess
            Button(action: {
                switch wordleState {
                case .daily:
                    dailyView.dailyViewModel.submitGuess(selectedSong: viewModel.selectedSong, selectedAlbum: viewModel.selectedAlbum)
                case .practice:
                    practiceView.practiceViewModel.submitGuess(selectedSong: viewModel.selectedSong, selectedAlbum: viewModel.selectedAlbum)
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
