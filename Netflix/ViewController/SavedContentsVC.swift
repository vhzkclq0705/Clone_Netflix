//
//  SavedContentsVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/15.
//

import UIKit
import SnapKit

class SavedContentsVC: UIViewController {
    
    var savedViewModel = SavedViewModel.shared
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SavedCell.self, forCellReuseIdentifier: SavedCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension SavedContentsVC { // About UI Setup
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        savedViewModel.loadMovies()
    }
}

extension SavedContentsVC: UITableViewDelegate, UITableViewDataSource { // About TableView Showing
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedViewModel.numOfMovies
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableViewHeaderView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedCell.identifier, for: indexPath) as? SavedCell else { return UITableViewCell() }
        
        cell.updateUI(savedViewModel.savedMovies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewVC()
        
        vc.modalPresentationStyle = .fullScreen
        vc.player.replaceCurrentItem(with: savedViewModel.playMovie(indexPath.row))
        vc.movieInfo = savedViewModel.savedMovies[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

extension SavedContentsVC { // About Cell and Header size
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = 50
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 80
        return height
    }
}

extension SavedContentsVC { // About Cell Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, success) in
            let movie = self.savedViewModel.savedMovies[indexPath.row]
            self.savedViewModel.deleteMovie(movie)
            self.tableView.reloadData()
        }
        
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}
