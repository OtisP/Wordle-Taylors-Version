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
        VStack(spacing: 2) {
            ForEach(practiceViewModel.songLyricsDisplayArray) { songLyricDisplay in
                HStack {
                    Spacer()
                    Text(songLyricDisplay.lyric)
                        .opacity(songLyricDisplay.isShown ? 1.0 : 0.0)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
                .background(practiceViewModel.lyricColors[songLyricDisplay.index])
                .frame(minHeight: 55)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}
