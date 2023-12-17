//
//  ContentView.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel(songs: fetchSongs())

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
                    ZStack {
                        Text("Wordle")
                            .font(.system(size: 28))
                            .foregroundColor(Color.black)
                    }
                    Text("(Taylor's Version)")
                        .font(.custom("charlotte", size: 28))
                        .foregroundColor(Color.black)
                    // Buttons to switch between daily and practice
                    HStack {
                        Button(action: { viewModel.wordleState = .daily }) {
                            Text("Daily")
                                .foregroundColor(viewModel.wordleState == .daily ? .white : .black)
                                .padding(10)
                                .background(viewModel.wordleState == .daily ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                        Button(action: { viewModel.wordleState = .practice }) {
                            Text("Practice")
                                .foregroundColor(viewModel.wordleState == .practice ? .white : .black)
                                .padding(10)
                                .background(viewModel.wordleState == .practice ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                    }
                }
                Spacer()
                // The views that display win/loss message and lyrics
                VStack {
                    switch viewModel.wordleState {
                    case .daily:
                        viewModel.dailyView
                    case .practice:
                        viewModel.practiceView
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
                        .cornerRadius(10)
                        .padding(10)
                    }
                    Divider()
                    HStack {
                        Spacer()
                        Text("Song")
                            .foregroundColor(Color.black)
                        Picker(selection: $viewModel.selectedSong, label: Text("Select a song")) {
                            ForEach(viewModel.songAndAlbumDict[viewModel.selectedAlbum] ?? [], id: \.self) { song in
                                Text(song.title).tag(song.title)
                                    .lineLimit(1)
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 300, minHeight: 40, maxHeight: 40)
                        .cornerRadius(10)
                        .padding([.horizontal, .vertical], 10)
                    }
                    Divider()
                }
                
                // Button to submit the guess
                Button(action: { viewModel.submitGuess() } ) {
                    Text("Submit")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

