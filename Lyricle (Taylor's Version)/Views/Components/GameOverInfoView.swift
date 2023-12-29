//
//  GameOverInfo.swift
//  Lyricle Taylors Version
//
//  Created by Otis Peterson on 12/21/23.
//

import SwiftUI

struct GameOverInfoView: View {
    let wonGame: Bool
    let winningSong: Song
    
    var body: some View {
        if wonGame == true {
            Text("Winner Yay!")
                .foregroundColor(.green)
                .bold()
        } else if wonGame == false {
            Text("So Close! Correct Answer:")
                .foregroundColor(.red)
                .bold()
            Text(
                (winningSong.title)
                + " - "
                + (winningSong.album)
            )
            .foregroundStyle(.black)
            .bold()
        }

    }
}

#Preview {
    GameOverInfoView(wonGame: false, winningSong: Song(title: "Sparks Fly", album: "Speak Now", lyrics: "The stor of us might be a tradgedy now"))
}
