//
//  DailyView.swift
//  Swiftical
//
//  Created by Otis Peterson on 12/28/22.
//

import SwiftUI

struct DailyView: View {
    @ObservedObject var dailyViewModel: DailyViewModel
    let songs: [Song]

    var body: some View {
        VStack {
            if let wonGame = dailyViewModel.wonGameBool,
                let winningSong = dailyViewModel.currentSong {
                GameOverInfoView(wonGame: wonGame, winningSong: winningSong)
                if let secondsTilMidnight = dailyViewModel.secondsTilMidnight {
                    Text("\(secondsTilMidnight.secondsToTimeDisplay) till next Swiftical")
                        .foregroundColor(.black)
                        .onReceive(dailyViewModel.timer) { _ in
                            dailyViewModel.secondsTilMidnight = Date.secondsTilMidnight - dailyViewModel.timerCount
                            if secondsTilMidnight < 1 {
                                dailyViewModel.loadTodaysSong(songs: songs)
                            }
                        }
                    Button(action: {
                        dailyViewModel.copyShareResults()
                    }) {
                        Text("Share Results")
                    }
                } else {
                    Text("")
                        .onReceive(dailyViewModel.timer) { _ in
                            dailyViewModel.secondsTilMidnight = Date.secondsTilMidnight - dailyViewModel.timerCount
                        }
                }
            }
            LyricDisplayView(viewModel: dailyViewModel)
        }
        // if the app is coming in from the background, check for a new song
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            dailyViewModel.loadTodaysSong(songs: songs)
        }
        .onAppear { dailyViewModel.loadTodaysSong(songs: songs) }
        .overlay {
            if dailyViewModel.showCopiedOverlay {
                Text("Copied to clipboard!")
                    .foregroundColor(Color.black)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .transition(.opacity)
            }
        }
    }
}
