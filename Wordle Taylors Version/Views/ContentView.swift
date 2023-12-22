//
//  ContentView.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()

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
            ScrollView {
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
                        Text("Album")
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 10)
                        Spacer()
                        Picker(selection: $viewModel.selectedAlbum, label: Text("Select an album")) {
                            ForEach(viewModel.albums, id: \.self) { album in
                                Text(album).tag(album)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    Divider()
                    HStack {
                        Text("Song")
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 10)
                        Spacer()
                        Picker(selection: $viewModel.selectedSong, label: Text("Select a song")) {
                            ForEach(viewModel.songAndAlbumDict[viewModel.selectedAlbum] ?? [], id: \.self) { song in
                                Text(song.title).tag(song.title)
                                    .lineLimit(1)
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    Divider()
                }
                
                // Button to submit the guess
                Button(action: { viewModel.submitGuess() } ) {
                    Text("Submit")
                }
                .padding(.bottom, 10)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    ContentView()
}

