//
//  SavedContentsVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/15.
//

import UIKit

class SavedContentsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var savedViewModel = SavedViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedViewModel.loadMovies()
        tableView.reloadData()
    }
    
}

extension SavedContentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedViewModel.numOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as? SavedCell else { return UITableViewCell() }
        
        cell.updateUI(savedViewModel.savedMovies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Player", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "PlayerViewVC") as? PlayerViewVC else { return }
        
        vc.modalPresentationStyle = .fullScreen
        vc.player.replaceCurrentItem(with: savedViewModel.playMovie(indexPath.row))
        vc.movieInfo = savedViewModel.savedMovies[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

extension SavedContentsVC {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            let movie = self.savedViewModel.savedMovies[indexPath.row]
            self.savedViewModel.deleteMovie(movie)
            self.tableView.reloadData()
        }
        
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension SavedContentsVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 80
        return height
    }
}
