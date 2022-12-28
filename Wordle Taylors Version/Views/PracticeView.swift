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
        ForEach(practiceViewModel.songLyricsDisplayArray) { songLyricDisplay in
            HStack {
                Spacer()
                Text(songLyricDisplay.isShown ? songLyricDisplay.lyric : "")
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .background(practiceViewModel.lyricColors[songLyricDisplay.index])
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
}
