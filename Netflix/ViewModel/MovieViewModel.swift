//
//  MovieViewModel.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/13.
//

import UIKit

enum Section: Int, CaseIterable {
    case award
    case hot
    case my
    
    var title: String {
        switch self {
        case .award: return "아카데미 호평 영화"
        case .hot: return "취향저격 HOT 콘텐츠"
        default: return "내가 찜한 콘텐츠"
        }
    }
}

class MovieViewModel {
    private (set) var type: Section = .my
    
    var recommendmovies = [RecommendMovie]()
    
    var numOfMovies: Int {
        return recommendmovies.count
    }
    
    func item(_ index: Int) -> RecommendMovie {
        return recommendmovies[index]
    }
    
    func updateType(_ type: Section) {
        self.type = type
    }
    
    func fetchMovies() {
        self.recommendmovies = fetch(type)
    }
}

extension MovieViewModel {
    func fetch(_ type: Section) -> [RecommendMovie] {
        switch type {
        case .award:
            let movies = (1..<10).map { RecommendMovie(thmbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .hot:
            let movies = (10..<19).map { RecommendMovie(thmbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        default:
            let movies = (1..<10).map { $0 * 2 }.map { RecommendMovie(thmbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        }
    }
}
