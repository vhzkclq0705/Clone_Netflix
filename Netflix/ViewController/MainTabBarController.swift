//
//  MainTabBarController.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/18.
//

import UIKit

class MainTabBarController: UITabBarController {

    let homeVC = HomeVC()
    let searchVC = SearchVC()
    let upcomingMoviesVC = UpcomingMoviesVC()
    let savedContentsVC = SavedContentsVC()
    
    let homeTab: UITabBarItem = {
        let tabBarItem: UITabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house.fill"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        return tabBarItem
    }()
    
    let searchTab: UITabBarItem = {
        let tabBarItem: UITabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        return tabBarItem
    }()
    
    let upcomingTab: UITabBarItem = {
        let tabBarItem: UITabBarItem = UITabBarItem(
            title: "공개예정",
            image: UIImage(systemName: "play.rectangle.fill"),
            selectedImage: UIImage(systemName: "play.rectangle.fill")
        )
        
        return tabBarItem
    }()
    
    let savedTab: UITabBarItem = {
        let tabBarItem: UITabBarItem = UITabBarItem(
            title: "저장한 콘텐츠 목록",
            image: UIImage(systemName: "square.and.arrow.down.fill"),
            selectedImage: UIImage(systemName: "square.and.arrow.down.fill")
        )
        
        return tabBarItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

extension MainTabBarController {    // About UI Setup
    func setupTabBar() {
        tabBar.tintColor = .white
        tabBar.backgroundColor = .systemGray6
        
        viewControllers = [homeVC, searchVC, upcomingMoviesVC, savedContentsVC]
        
        homeVC.tabBarItem = homeTab
        searchVC.tabBarItem = searchTab
        upcomingMoviesVC.tabBarItem = upcomingTab
        savedContentsVC.tabBarItem = savedTab
    }
}
