//
//  PracticeView.swift
//  Lyricle Taylors Version
//
//  Created by Otis Peterson on 12/28/22.
//

import SwiftUI

struct PracticeView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel

    var body: some View {
        VStack{
            if let wonGame = practiceViewModel.wonGameBool,
                let winningSong = practiceViewModel.currentSong {
                GameOverInfoView(wonGame: wonGame, winningSong: winningSong)
                Button(action: { practiceViewModel.loadTodaysSong(songs: practiceViewModel.songs) }) {
                    Text("Start New Game +")
                }
            }
            LyricDisplayView(viewModel: practiceViewModel)
        }
    }
}
