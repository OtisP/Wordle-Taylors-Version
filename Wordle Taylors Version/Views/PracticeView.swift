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
                .frame(minHeight: ViewConstants.lyricFrameHeight)
                .cornerRadius(ViewConstants.lyricCornerRadius)
                .padding(.horizontal)
            }
        }
    }
}
