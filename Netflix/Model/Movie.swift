//
//  Movie.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/13.
//

import Foundation

struct Movie: Codable, Equatable {
    let title: String
    let director: String
    let thumbnailPath: String
    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
    }
}
