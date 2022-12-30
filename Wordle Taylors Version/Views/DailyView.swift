//
//  DailyView.swift
//  Wordle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import SwiftUI

struct DailyView: View {
    @ObservedObject var dailyViewModel: DailyViewModel

    var body: some View {
        VStack {
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
                //TODO: a countdown to next wordle should be here
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
