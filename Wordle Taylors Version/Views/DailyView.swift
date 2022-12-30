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
        VStack(spacing: 2) {
            ForEach(dailyViewModel.songLyricsDisplayArray) { songLyricDisplay in
                HStack {
                    Spacer()
                    Text(songLyricDisplay.lyric)
                        .opacity(songLyricDisplay.isShown ? 1.0 : 0.0)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
                .background(dailyViewModel.lyricColors[songLyricDisplay.index])
                .frame(minHeight: 55)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}
