//
//  MainTabController.swift
//  YouTubeClone
//
//  Created by yujaehong on 4/15/24.
//

import UIKit

final class MainTabController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    private func configureViewControllers() {
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .white
        
        let home = templateNavigationViewController(title: "홈",
                                                    unselectedImage: UIImage(named: "homeIcon")!,
                                                    selectedImage: UIImage(named: "homeIconFill")!,
                                                    rootViewController: HomeViewController())
        
        let shorts = templateNavigationViewController(title: "Shorts",
                                                      unselectedImage: UIImage(named: "shortsIcon")!,
                                                      selectedImage: UIImage(named: "shortsIconFill")!, 
                                                      rootViewController: ShortsViewController())
        
        let add = templateNavigationViewController(title: "추가",
                                                   unselectedImage: UIImage(named: "plueCircleIcon")!,
                                                   selectedImage: UIImage(named: "plueCircleIcon")!,
                                                   rootViewController: AddViewController())
        
        let sub = templateNavigationViewController(title: "구독",
                                                   unselectedImage: UIImage(named: "subscriptionsIcon")!,
                                                   selectedImage: UIImage(named: "subscriptionsIconFill")!,
                                                   rootViewController: SubscribeViewController())
        
        let strg = templateNavigationViewController(title: "삭제",
                                                    unselectedImage: UIImage(named: "LibraryIcon")!,
                                                    selectedImage: UIImage(named: "LibraryIconFill")!,
                                                    rootViewController: StorageViewController())
                                                    
        viewControllers = [home, shorts, add, sub, strg]
        tabBar.tintColor = .black
    }
    
    private func templateNavigationViewController(title: String,
                                                  unselectedImage: UIImage?,
                                                  selectedImage: UIImage?,
                                                  rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}
