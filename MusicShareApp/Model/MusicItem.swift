//
//  MusicItem.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/21.
//

import Foundation
import SwiftUI

struct MusicItem: Codable, Identifiable {
    var id = UUID()
    var musicName: String
    var artistName: String
    var previewUrl: String
    var imageUrl: String
    
    enum CodingKeys:String, CodingKey {
        case musicName = "trackCensoredName"
        case artistName = "artistName"
        case previewUrl = "previewUrl"
        case imageUrl = "artworkUrl60"
    }
    
}

