//
//  PracticeView.swift
//  Wordle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import SwiftUI

struct PracticeView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel

    var body: some View {
        VStack{
            if let wonGame = practiceViewModel.wonGameBool {
                if wonGame == true {
                    Text("Winner Yay!")
                        .foregroundColor(.green)
                        .bold()
                } else if wonGame == false {
                    Text("So Close! Correct Answer:")
                        .foregroundColor(.red)
                        .bold()
                    Text(
                        (practiceViewModel.currentSong?.title ?? "")
                        + " - "
                        + (practiceViewModel.currentSong?.album ?? "")
                    )
                    .foregroundColor(.black)
                    .bold()
                }
                Button(action: { practiceViewModel.getSong(songs: practiceViewModel.songs) }) {
                    Text("Start New Game +")
                }
            }
            VStack(spacing: ViewConstants.wordleVStackSpacing) {
                ForEach(practiceViewModel.songLyricsDisplayArray) { songLyricDisplay in
                    HStack {
                        Spacer()
                        Text(songLyricDisplay.lyric)
                            .opacity(songLyricDisplay.isShown ? 1.0 : 0.0)
                            .minimumScaleFactor(ViewConstants.lyricMinScaleFactor)
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                    }
                    .background(practiceViewModel.lyricColors[songLyricDisplay.index])
                    .cornerRadius(ViewConstants.lyricCornerRadius)
                    .padding(.horizontal)
                }
            }
        }
    }
}
