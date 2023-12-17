//
//  DailyView.swift
//  Wordle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import SwiftUI

struct DailyView: View {
    @ObservedObject var dailyViewModel: DailyViewModel
    let songs: [Song]

    var body: some View {
        VStack {
            if let wonGame = dailyViewModel.wonGameBool {
                if wonGame == true {
                    Text("Winner Yay!")
                        .foregroundColor(.green)
                        .bold()
                } else if wonGame == false {
                    Text("So Close! Correct Answer:")
                        .foregroundColor(.red)
                        .bold()
                    Text(
                        (dailyViewModel.currentSong?.title ?? "")
                        + " - "
                        + (dailyViewModel.currentSong?.album ?? "")
                    )
                    .bold()
                }
                if let secondsTilMidnight = dailyViewModel.secondsTilMidnight {
                    Text("\(secondsTilMidnight.secondsToTimeDisplay) till next Wordle (TV)")
                        .foregroundColor(.black)
                        .onReceive(dailyViewModel.timer) { _ in
                            dailyViewModel.secondsTilMidnight = Date.secondsTilMidnight - dailyViewModel.timerCount
                            if secondsTilMidnight < 1 {
                                dailyViewModel.getSong(songs: songs)
                            }
                        }
                } else {
                    Text("")
                        .onReceive(dailyViewModel.timer) { _ in
                            dailyViewModel.secondsTilMidnight = Date.secondsTilMidnight - dailyViewModel.timerCount
                        }
                }
            }
            VStack(spacing: ViewConstants.wordleVStackSpacing) {
                ForEach(dailyViewModel.songLyricsDisplayArray) { songLyricDisplay in
                    HStack {
                        Spacer()
                        Text(songLyricDisplay.lyric)
                            .opacity(songLyricDisplay.isShown ? 1.0 : 0.0)
                            .minimumScaleFactor(ViewConstants.lyricMinScaleFactor)
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                    }
                    .background(dailyViewModel.lyricColors[songLyricDisplay.index])
                    .frame(minHeight: ViewConstants.lyricFrameHeight)
                    .cornerRadius(ViewConstants.lyricCornerRadius)
                    .padding(.horizontal)
                }
            }
        }
    }
}
