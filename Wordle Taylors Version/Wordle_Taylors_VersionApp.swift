//
//  Wordle_Taylors_VersionApp.swift
//  Wordle Taylors Version
//
//  Created by Otis Peterson on 12/27/22.
//

import SwiftUI

@main
struct Wordle_Taylors_VersionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
