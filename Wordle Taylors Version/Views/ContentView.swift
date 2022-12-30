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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                Color(red: 253/255, green: 205/255, blue: 205/255),
                Color(red: 222/255, green: 192/255, blue: 252/255),
                Color(red: 206/255, green: 192/255, blue: 252/255),
                Color(red: 174/255, green: 192/255, blue: 252/255),
                Color(red: 148/255, green: 225/255, blue: 234/255)
                ]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
                .edgesIgnoringSafeArea(.all)
            VStack {
                // The header of the app -- title etc
                VStack(spacing: 5) {
                    Text("Wordle")
                        .font(.system(size: 28))
                        .foregroundColor(Color.black)
                    Text("(Taylor's Version)")
                        .font(.custom("charlotte", size: 28))
                        .foregroundColor(Color.black)
                    // Buttons to switch between daily and practice
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
                    
                    VStack {
                        switch wordleState {
                        case .daily:
                            if let wonGame = dailyViewModel.wonGameBool {
                                if wonGame == true {
                                    Text("Winner yay")
                                        .foregroundColor(.green)
                                        .bold()
                                } else if wonGame == false {
                                    Text("Loser Boo, the right answer was:")
                                        .foregroundColor(.red)
                                        .bold()
                                    Text(
                                        (dailyViewModel.currentSong?.title ?? "")
                                        + " - "
                                        + (dailyViewModel.currentSong?.album ?? "")
                                    )
                                    .bold()
                                }
                            }
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
                                    Text(
                                        (practiceViewModel.currentSong?.title ?? "")
                                        + " - "
                                        + (practiceViewModel.currentSong?.album ?? "")
                                    )
                                    .bold()
                                }
                                Button(action: { practiceViewModel.getSong(songs: viewModel.songs) }) {
                                    Text("Start New Game +")
                                }
                            }
                        }
                    }
                    Spacer()
                }
                // The views that display the lyrics
                VStack {
                    switch wordleState {
                    case .daily:
                        dailyView
                    case .practice:
                        practiceView
                    }
                }
                // The album and song selectors
                VStack(alignment: .leading) {
                    Divider()
                    HStack {
                        Spacer()
                        Text("Album")
                            .foregroundColor(Color.black)
                        Picker(selection: $viewModel.selectedAlbum, label: Text("Select an album")) {
                            ForEach(viewModel.albums, id: \.self) { album in
                                Text(album).tag(album)
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 300, minHeight: 40, maxHeight: 40)
                    }
                    Divider()
                    HStack {
                        Spacer()
                        Text("Song")
                            .foregroundColor(Color.black)
                        Picker(selection: $viewModel.selectedSong, label: Text("Select a song")) {
                            ForEach(viewModel.songAndAlbumDict[viewModel.selectedAlbum] ?? [], id: \.self) { song in
                                Text(song)
                                    .lineLimit(1)
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 300, minHeight: 40, maxHeight: 40)
                    }
                    Divider()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
