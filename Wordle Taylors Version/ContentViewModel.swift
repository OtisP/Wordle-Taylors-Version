//
//  ContentViewModel.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI
import CSwiftV

class ContentViewModel: ObservableObject {
    @Published var songs: [Song] = []
    @Published var currentSong: Song?
    @Published var songLyricsDisplayArray: [SongLyricDisplay] = []
    @Published var lyricColors: [Color] = Array(repeating: Color.gray, count: 6)

    @Published var guess: String = ""
    @Published var selectedAlbum = ""
    @Published var selectedSong = ""

    let albums: [String]
    var songAndAlbumDict: [String: [String]] = [:]
    var guessIndex: Int = 0

    init() {
        let fetchedSongs = fetchSongs()
        songs = fetchedSongs

        var albumSet: Set<String> = Set()
        for song in fetchedSongs {
            albumSet.insert(song.album)
            if songAndAlbumDict[song.album] != nil {
                songAndAlbumDict[song.album]?.append(song.title)
            } else {
                songAndAlbumDict[song.album] = [song.title]
            }
        }
        let albumArray = Array(albumSet)
        albums = albumArray.sorted { $0 < $1 }
        getNewSong()
    }

    func submitGuess() {
        // update the color
        updateColor(guessIndex - 1)
        // Check if the guess is correct
        if selectedSong.lowercased() == currentSong?.title.lowercased() {
            // Reveal the lyrics and reset the game after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.getNewSong()
                return
            }
        } else {
            // Incorrect guess reveal a lyric
            revealSongLyric()
        }
    }

    func getNewSong() {
        currentSong = songs.randomElement()
        print(currentSong?.title ?? "")
        guard let songLyricsDisplayArray = currentSong?.displayLyrics else { return }
        self.songLyricsDisplayArray = songLyricsDisplayArray
        guessIndex = 0
        lyricColors = Array(repeating: Color.gray, count: 6)
        
        revealSongLyric()
    }

    func revealSongLyric() {
        if guessIndex >= songLyricsDisplayArray.count {
            // Reveal the song lyric because they are out of guesses
            getNewSong()
            return
        }

        songLyricsDisplayArray[guessIndex].flipShownProperty()
        guessIndex += 1
    }
    
    func updateColor(_ guessidx: Int) {
        if selectedAlbum == currentSong?.album && selectedSong == currentSong?.title {
            lyricColors[guessidx] = Color.green
        } else if selectedAlbum == currentSong?.album {
            lyricColors[guessidx] = Color.orange
        } else {
            lyricColors[guessidx] = Color.red
        }
    }

}

func fetchSongs() -> [Song] {
    // locate the file you want to use
    guard let filepath = Bundle.main.path(forResource: "songs", ofType: "csv") else {
        return []
    }

    // convert that file into one long string
    var data = ""
    do {
        data = try String(contentsOfFile: filepath)
    } catch {
        print(error)
        return []
    }

    let csv = CSwiftV.init(with: data)
    return csv.rows.map { Song(title: $0[0], album: $0[1], lyrics: $0[2]) }
}
