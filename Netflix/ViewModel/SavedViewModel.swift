//
//  SavedViewModel.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/16.
//

import UIKit
import AVFoundation

class SavedViewModel {
    static let shared = SavedViewModel()
    
    private init() {}
    
    var savedMovies = [Movie]()
    
    var numOfMovies: Int {
        return savedMovies.count
    }
    
    func playMovie(_ index: Int) -> AVPlayerItem {
        let url = URL(string: savedMovies[index].previewURL)!
        
        return AVPlayerItem(url: url)
    }
    
    func createMovie(title: String, director: String, thumnailPath: String, previewURL: String) -> Movie {
        return Movie(title: title, director: director, thumbnailPath: thumnailPath, previewURL: previewURL)
    }
    
    func addMovie(_ movie: Movie) {
        savedMovies.append(movie)
        saveMovies()
    }
    
    func deleteMovie(_ movie: Movie) {
        savedMovies = savedMovies.filter{ $0 != movie }
        saveMovies()
    }
    
    func saveMovies() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(savedMovies), forKey: "savedMovies")
        print("저장완료")
    }
    
    func loadMovies() {
        guard let data = UserDefaults.standard.data(forKey: "savedMovies") else { return }
        savedMovies = (try? PropertyListDecoder().decode([Movie].self, from: data)) ?? []
        print("불러오기완료 --> \(savedMovies)")
    }
    
    func checkMovie(_ movie: Movie) -> Bool {
        if (savedMovies.firstIndex(of: movie) != nil) {
            // movie가 저장목록에 있다면 true 반환
            return true
        } else {
            return false
        }
    }
}
