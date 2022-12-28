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
        ForEach(dailyViewModel.songLyricsDisplayArray) { songLyricDisplay in
            HStack {
                Spacer()
                Text(songLyricDisplay.isShown ? songLyricDisplay.lyric : "")
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .background(dailyViewModel.lyricColors[songLyricDisplay.index])
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
}
