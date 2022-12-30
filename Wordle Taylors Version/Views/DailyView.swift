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
