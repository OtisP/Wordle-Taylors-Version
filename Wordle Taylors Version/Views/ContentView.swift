//
//  ContentView.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel(songs: fetchSongs())
    // TODO I want to change these state vars to one state var that has an enum as its value so
    // I can just switch on that
    @State private var isDailyActive = true
    @State private var isPracticeActive = false
    
    var dailyView: DailyView
    
    init() {
        dailyView = DailyView(dailyViewModel: DailyViewModel())
        dailyView.dailyViewModel.getSong(songs: viewModel.songs)
    }

    var body: some View {
        VStack {
            Text("Wordle (Taylor's Version)")
                .font(.headline)
            
            HStack {
                Button(action: {
                    self.isDailyActive = true
                    self.isPracticeActive = false
                }) {
                    Text("Daily")
                        .foregroundColor(self.isDailyActive ? .white : .black)
                        .padding(10)
                        .background(self.isDailyActive ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }

                Button(action: {
                    self.isPracticeActive = true
                    self.isDailyActive = false
                }) {
                    Text("Practice")
                        .foregroundColor(self.isPracticeActive ? .white : .black)
                        .padding(10)
                        .background(self.isPracticeActive ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
            }

            if isDailyActive{
                dailyView
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

            // TODO: this will have to be a switch as well
            // Button to submit the guess
            Button(action: { dailyView.dailyViewModel.submitGuess(selectedSong: viewModel.selectedSong, selectedAlbum: viewModel.selectedAlbum) } ) {
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
