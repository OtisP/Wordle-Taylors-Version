//
//  ContentViewModel.swift
//  SwiftLyricDle
//
//  Created by Otis Peterson on 12/25/22.
//

import SwiftUI
import SQLite3

class ContentViewModel: ObservableObject {
    @Published var selectedAlbum: String {
        willSet {
            selectedSong = (songAndAlbumDict[newValue]?[0].title) ?? ""
        }
    }
    @Published var selectedSong: String
    @Published var lyricleState: LyricleState = .daily

    var songAndAlbumDict: [String : [Song]] = [:]
    let songs: [Song]
    var albums: [String] {
        let albumKeys = songAndAlbumDict.keys
        return albumKeys.sorted { $0.mapAlbums() < $1.mapAlbums() }
    }

    @Published var dailyViewModel: DailyViewModel
    @Published var practiceViewModel: PracticeViewModel
    var dailyView: DailyView
    var practiceView: PracticeView

    init() {
        var db: OpaquePointer?

        var songList: [Song] = []
        guard let dbPath = Bundle.main.path(forResource: "songs", ofType: "sqlite")  else {
            fatalError()
        }
        
        // Open the database
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")

            var statement: OpaquePointer?

            let query = "SELECT * FROM songs;"

            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    // Access results
                    let songTitle = String(cString: sqlite3_column_text(statement, 0))
                    let songAlbum = String(cString: sqlite3_column_text(statement, 1))
                    let songLyrics = String(cString: sqlite3_column_text(statement, 2))

                    songList.append(Song(title: songTitle, album: songAlbum, lyrics: songLyrics))
                }
            } else {
                fatalError("Error preparing SQL statement")
            }

            // Finalize the statement to release resources
            sqlite3_finalize(statement)
        } else {
            fatalError("Unable to open database.")
        }

        // Close the database connection
        sqlite3_close(db)

        self.songs = songList.sorted { $0.title.mapSongs() < $1.title.mapSongs() }
        for song in self.songs {
            if songAndAlbumDict[song.album] != nil {
                songAndAlbumDict[song.album]?.append(song)
            } else {
                songAndAlbumDict[song.album] = [song]
            }
        }
        
        selectedAlbum = songs[0].album
        selectedSong = songs[0].title

        let decoder = JSONDecoder()

        // MARK: DailyView
        // If there is state saved in the DailyViewModel then load it
        var dailyViewModel: DailyViewModel
        if let savedDailyViewModel = UserDefaults.standard.object(forKey: "dailyViewModel") as? Data,
           let unwrappedDailyViewModel = try? decoder.decode(DailyViewModel.self, from: savedDailyViewModel) {
            dailyViewModel = unwrappedDailyViewModel
        } else {
            dailyViewModel = DailyViewModel()
        }
        dailyView = DailyView(dailyViewModel: dailyViewModel, songs: songs)
        self.dailyViewModel = dailyViewModel
        dailyView.dailyViewModel.loadTodaysSong(songs: songs)

        // MARK: PracticeView
        let practiceViewModel = PracticeViewModel(songs: songs)
        practiceView = PracticeView(practiceViewModel: practiceViewModel)
        self.practiceViewModel = practiceViewModel
        practiceView.practiceViewModel.loadTodaysSong(songs: songs)

        self.selectedAlbum = albums[0]
        self.selectedSong = songAndAlbumDict[selectedAlbum]?[0].title ?? ""
    }
    
    func submitGuess() {
        switch lyricleState {
        case .daily:
            guard !dailyViewModel.gameOver else { return }
            dailyViewModel.submitGuess(selectedSong: selectedSong, selectedAlbum: selectedAlbum)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(dailyViewModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "dailyViewModel")
            }
        case .practice:
            guard !practiceViewModel.gameOver else { return }
            practiceViewModel.submitGuess(selectedSong: selectedSong, selectedAlbum: selectedAlbum)
        }
    }
}

private extension String {
    func mapAlbums() -> Int {
        switch self {
        case "Debut":
            return 0
        case "Fearless (TV)":
            return 1
        case "Speak Now (TV)":
            return 2
        case "Red (TV)":
            return 3
        case "1989 (TV)":
            return 4
        case "Reputation":
            return 5
        case "Lover":
            return 6
        case "folklore":
            return 7
        case "evermore":
            return 8
        case "Midnights":
            return 9
        default:
            return 11
        }
    }
    
    func mapSongs() -> Int {
        switch self {
        case "Tim McGraw": return 1
        case "Picture to Burn": return 2
        case "Teardrops On My Guitar": return 3
        case "A Place In This World": return 4
        case "Cold as You": return 5
        case "The Outside": return 6
        case "Tied Together with a Smile": return 7
        case "Stay Beautiful": return 8
        case "Should've Said No": return 9
        case "Mary's Song (Oh My My My)": return 10
        case "Our Song": return 11
        case "I Heart ?": return 12
        case "I'm Only Me When I'm With You": return 13
        case "Invisible": return 14
            
        case "A Perfectly Good Heart": return 101
        case "Fearless": return 102
        case "Fifteen": return 103
        case "Love Story": return 104
        case "Hey Stephen": return 105
        case "White Horse": return 106
        case "You Belong With Me": return 107
        case "Breathe": return 108
        case "Tell Me Why": return 109
        case "You're Not Sorry": return 110
        case "The Way I Loved You": return 111
        case "Forever & Always": return 112
        case "The Best Day": return 113
        case "Change": return 114
        case "Jump Then Fall": return 115
        case "Untouchable": return 116
        case "Come In With The Rain": return 117
        case "Superstar": return 118
        case "The Other Side of the Door": return 119
        case "Today Was a Fairytale": return 120
        case "You All Over Me [FTV]": return 121
        case "Mr. Perfectly Fine [FTV]": return 122
        case "We Were Happy [FTV]": return 123
        case "That's When [FTV]": return 124
        case "Don't You [FTV]": return 125
        case "Bye Bye Baby [FTV]": return 126
            
        case "Mine": return 201
        case "Sparks Fly": return 202
        case "Back To December": return 203
        case "Speak Now": return 204
        case "Dear John": return 205
        case "Mean": return 206
        case "The Story Of Us": return 207
        case "Never Grow Up": return 208
        case "Enchanted": return 209
        case "Better Than Revenge": return 210
        case "Innocent": return 211
        case "Haunted": return 212
        case "Last Kiss": return 213
        case "Long Live": return 214
        case "Ours": return 215
        case "If This Was a Movie": return 216
        case "Superman": return 217
        case "Electric Touch [FTV]": return 218
        case "When Emma Falls in Love [FTV]": return 219
        case "I Can See You [FTV]": return 220
        case "Castles Crumbling [FTV]": return 221
        case "Foolish One [FTV]": return 222
        case "Timeless [FTV]": return 223
            
        case "Red": return 301
        case "Treacherous": return 302
        case "I Knew You Were Trouble": return 303
        case "All Too Well": return 304
        case "22": return 305
        case "I Almost Do": return 306
        case "We Are Never Ever Getting Back Together": return 307
        case "Stay Stay Stay": return 308
        case "The Last Time": return 309
        case "Holy Ground": return 310
        case "Sad Beautiful Tragic": return 311
        case "The Lucky One": return 312
        case "Everything Has Changed": return 313
        case "Starlight": return 314
        case "Begin Again": return 315
        case "The Moment I Knew": return 316
        case "Come Back... Be Here": return 317
        case "Girl At Home": return 318
        case "State of Grace": return 319
        case "Ronan": return 320
        case "Better Man [FTV]": return 321
        case "Nothing New [FTV]": return 322
        case "Babe [FTV]": return 323
        case "Message In A Bottle [FTV]": return 324
        case "I Bet You Think About Me [FTV]": return 325
        case "Forever Winter [FTV]": return 326
        case "Run [FTV]": return 327
        case "The Very First Night [FTV]": return 328
        case "All Too Well (10 Minute Version) [FTV]": return 329
            
        case "Welcome To New York": return 401
        case "Blank Space": return 402
        case "Style": return 403
        case "Out Of The Woods": return 404
        case "All You Had To Do Was Stay": return 405
        case "Shake It Off": return 406
        case "I Wish You Would": return 407
        case "Bad Blood": return 408
        case "Wildest Dreams": return 409
        case "How You Get The Girl": return 410
        case "This Love": return 411
        case "I Know Places": return 412
        case "Clean": return 413
        case "Wonderland": return 414
        case "You Are In Love": return 415
        case "New Romantics": return 416
        case "\"Slut!\" [FTV]": return 417
        case "Say Don't Go [FTV]": return 418
        case "Now That We Don't Talk [FTV]": return 419
        case "Suburban Legends [FTV]": return 420
        case "Is It Over Now? [FTV]": return 421
        case "Sweeter Than Fiction": return 422
        case "Bad Blood (Remix)": return 423
            
        case "...Ready for It?": return 501
        case "End Game": return 502
        case "I Did Something Bad": return 503
        case "Don't Blame Me": return 504
        case "Delicate": return 505
        case "Look What You Made Me Do": return 506
        case "So It Goes...": return 507
        case "Gorgeous": return 508
        case "Getaway Car": return 509
        case "King of My Heart": return 510
        case "Dancing With Our Hands Tied": return 511
        case "Dress": return 512
        case "This Is Why We Can't Have Nice Things": return 513
        case "Call It What You Want": return 514
        case "New Year's Day": return 515
            
        case "I Forgot That You Existed": return 601
        case "Cruel Summer": return 602
        case "Lover": return 603
        case "The Man": return 604
        case "The Archer": return 605
        case "I Think He Knows": return 606
        case "Miss Americana & The Heartbreak Prince": return 607
        case "Paper Rings": return 608
        case "Cornelia Street": return 609
        case "Death By A Thousand Cuts": return 610
        case "London Boy": return 611
        case "Soon You'll Get Better": return 612
        case "False God": return 613
        case "You Need To Calm Down": return 614
        case "Afterglow": return 615
        case "ME!": return 616
        case "It's Nice To Have A Friend": return 617
        case "Daylight": return 618
        case "All Of The Girls You Loved Before [FTV]": return 619
            
        case "the 1": return 701
        case "cardigan": return 702
        case "the last great american dynasty": return 703
        case "exile": return 704
        case "my tears ricochet": return 705
        case "mirrorball": return 706
        case "seven": return 707
        case "august": return 708
        case "this is me trying": return 709
        case "illicit affairs": return 710
        case "invisible string": return 711
        case "mad woman": return 712
        case "epiphany": return 713
        case "betty": return 714
        case "peace": return 715
        case "hoax": return 716
        case "the lakes": return 717
            
        case "willow": return 801
        case "champagne problems": return 802
        case "gold rush": return 803
        case "'tis the damn season": return 804
        case "tolerate it": return 805
        case "no body, no crime": return 806
        case "happiness": return 807
        case "dorothea": return 808
        case "coney island": return 809
        case "ivy": return 810
        case "cowboy like me": return 811
        case "long story short": return 812
        case "marjorie": return 813
        case "closure": return 814
        case "evermore": return 815
        case "right where you left me": return 816
        case "it's time to go": return 817
            
        case "Lavender Haze": return 901
        case "Maroon": return 902
        case "Anti-Hero": return 903
        case "Snow On The Beach": return 904
        case "You're On Your Own, Kid": return 905
        case "Midnight Rain": return 906
        case "Question...?": return 907
        case "Vigilante Shit": return 908
        case "Bejeweled": return 909
        case "Labyrinth": return 910
        case "Karma": return 911
        case "Sweet Nothing": return 912
        case "Mastermind": return 913
        case "The Great War": return 914
        case "Bigger Than The Whole Sky": return 915
        case "Paris": return 916
        case "High Infidelity": return 917
        case "Glitch": return 918
        case "Would've, Could've, Should've": return 919
        case "Dear Reader": return 920
        case "Hits Different": return 921
        case "You're Losing Me [FTV]": return 922
            
        case "Last Christmas": return 1001
        case "Christmases When You Were Mine": return 1002
        case "Santa Baby": return 1003
        case "Silent Night": return 1004
        case "Christmas Must Be Something More": return 1005
        case "White Christmas": return 1006
            
        default:
            print("Unlabeled songs:\(self)")
            return 10000
        }
    }
}
