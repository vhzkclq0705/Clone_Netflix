//
//  SearchViewModel.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/14.
//

import UIKit
import AVFoundation

class SearchViewModel {
    var searchMovies = [Movie]()
    
    var numOfMovies: Int {
        return searchMovies.count
    }
    
    func searchMovies(_ term: String, completion: @escaping () -> Void) {
        SearchAPI.search(term) { movies in
            self.searchMovies = movies
            completion()
        }
    }
    
    func showThumbnail(_ index: Int) -> URL {
        return URL(string: searchMovies[index].thumbnailPath)!
    }
    
    func playMovie(_ index: Int) -> AVPlayerItem {
        let url = URL(string: searchMovies[index].previewURL)!
        
        return AVPlayerItem(url: url)
    }
}
