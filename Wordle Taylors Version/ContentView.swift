//
//  ContentView.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.songLyricsDisplayArray) { songLyricDisplay in
                HStack {
                    Spacer()
                    Text(songLyricDisplay.isShown ? songLyricDisplay.lyric : "")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.gray)
                .frame(minWidth: 0, maxWidth: .infinity)
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
