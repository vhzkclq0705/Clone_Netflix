//
//  HomeVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/09.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {
   
    var awardRecommendListVC: RecommendListVC!
    var hotRecommendListVC: RecommendListVC!
    var myRecommendListVC: RecommendListVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? RecommendListVC
        switch segue.identifier {
        case "award":
            awardRecommendListVC = destination
            awardRecommendListVC.viewModel.updateType(.award)
            awardRecommendListVC.viewModel.fetchMovies()
        case "hot":
            hotRecommendListVC = destination
            hotRecommendListVC.viewModel.updateType(.hot)
            hotRecommendListVC.viewModel.fetchMovies()
        default:
            myRecommendListVC = destination
            myRecommendListVC.viewModel.updateType(.my)
            myRecommendListVC.viewModel.fetchMovies()
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        SearchAPI.search("interstella") { movies in
            guard let interstella = movies.first else { return }
            
            DispatchQueue.main.async {
                let url = URL(string: interstella.previewURL)!
                let item = AVPlayerItem(url: url)
                let sb = UIStoryboard(name: "Player", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "PlayerViewVC") as! PlayerViewVC
                vc.player.replaceCurrentItem(with: item)
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
}
