//
//  ContentView.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var isDailyActive = true
    @State private var isPracticeActive = false
    
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

            ForEach(viewModel.songLyricsDisplayArray) { songLyricDisplay in
                HStack {
                    Spacer()
                    Text(songLyricDisplay.isShown ? songLyricDisplay.lyric : "")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(viewModel.lyricColors[songLyricDisplay.index])
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.horizontal)
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
            Button(action: viewModel.submitGuess) {
                Text("Submit")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
