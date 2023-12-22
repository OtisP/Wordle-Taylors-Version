//
//  LyricDisplayView.swift
//  Wordle Taylors Version
//
//  Created by Otis Peterson on 12/21/23.
//

import SwiftUI

struct LyricDisplayView<Model>: View where Model: WordleViewModelProtocol {
    @ObservedObject var viewModel: Model
    
    var body: some View {
        VStack(spacing: ViewConstants.wordleVStackSpacing) {
            ForEach(viewModel.songLyricsDisplayArray) { songLyricDisplay in
                HStack {
                    Spacer()
                    Text(songLyricDisplay.lyric)
                        .opacity(songLyricDisplay.isShown ? 1.0 : 0.0)
                        .minimumScaleFactor(ViewConstants.lyricMinScaleFactor)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
                .background(viewModel.lyricColors[songLyricDisplay.index])
                .cornerRadius(ViewConstants.lyricCornerRadius)
                .padding(.horizontal)
            }
        }
    }
}
