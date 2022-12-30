//
//  ContentViewModel.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI
import CSwiftV

class ContentViewModel: ObservableObject {
    @Published var selectedAlbum = ""
    @Published var selectedSong = ""
    var songAndAlbumDict: [String : [String]] = [:]
    let songs: [Song]
    var albums: [String] {
        let albumKeys = songAndAlbumDict.keys
        return albumKeys.sorted { $0 < $1 }
    }

    init(songs: [Song]) {
        self.songs = songs
        for song in self.songs {
            if songAndAlbumDict[song.album] != nil {
                songAndAlbumDict[song.album]?.append(song.title)
            } else {
                songAndAlbumDict[song.album] = [song.title]
            }
        }
        self.selectedAlbum = albums[0]
        self.selectedSong = songAndAlbumDict[selectedAlbum]?[0] ?? ""
    }
}
