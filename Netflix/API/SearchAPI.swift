//
//  SearchAPI.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/13.
//

import UIKit

class SearchAPI {
    static func search(_ term: String, completion: @escaping ([Movie]) -> Void) {
        var components = URLComponents(string: "https://itunes.apple.com/search?")!
        let media = URLQueryItem(name: "media", value: "movie")
        let entity = URLQueryItem(name: "entity", value: "movie")
        let movieName = URLQueryItem(name: "term", value: term)
        
        components.queryItems = [media, entity, movieName]
        let url = components.url!
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            let successRange = 200..<300
            
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                completion([])
                return
            }
            
            guard let resultData = data else {
                completion([])
                return
            }
            
            // data -> [Movie]
            let movies = SearchAPI.parseMovies(resultData)
            completion(movies)
            
        }
        dataTask.resume()
    }
    
    static func parseMovies(_ data: Data) -> [Movie] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let movies = response.movies
            return movies
        } catch let error {
            print("--> parsing error: \(error.localizedDescription)")
            return []
        }
    }
}
