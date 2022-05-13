//
//  Response.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/13.
//

import Foundation

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}
