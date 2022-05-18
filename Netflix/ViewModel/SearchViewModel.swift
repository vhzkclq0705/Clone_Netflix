//
//  SearchViewModel.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/14.
//

import UIKit
import AVFoundation

class SearchViewModel {
    var movies = [Movie]()
    
    var numOfMovies: Int {
        return movies.count
    }
    
    func searchMovies(_ term: String, completion: @escaping () -> Void) {
        SearchAPI.search(term) { movies in
            self.movies = movies
            completion()
        }
    }
    
    func showThumbnail(_ index: Int) -> URL {
        return URL(string: movies[index].thumbnailPath)!
    }
    
    func playMovie(_ index: Int) -> AVPlayerItem {
        let url = URL(string: movies[index].previewURL)!
        
        return AVPlayerItem(url: url)
    }
}
