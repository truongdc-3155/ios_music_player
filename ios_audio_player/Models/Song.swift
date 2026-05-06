//
//  Song.swift
//  ios_audio_player
//
//  Created by dang.chi.truong on 4/5/26.
//

import Foundation

struct Song {
    let name: String
    let fileName: String
    let performer: String
    let thumbnail: String
    
    
    static func getPlayList() -> [Song] {
        var songs: [Song] = []
        songs.append(Song(name: "Audio ONE", fileName: "audio_one", performer: "This is audio one", thumbnail: "image_one"))
        songs.append(Song(name: "Audio TWO", fileName: "audio_two", performer: "This is audio two", thumbnail: "image_two"))
        songs.append(Song(name: "Audio Three", fileName: "audio_three", performer: "This is audio three", thumbnail: "image_three"))
        return songs
    }
}
