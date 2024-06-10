//
//  HomeViewController.swift
//  YouTubeClone
//
//  Created by yujaehong on 4/15/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLeftNavigationItem()
        setupRightNavigationItems()
    }
    
    // MARK: - Method
    
    private func setupLeftNavigationItem() {
        let logoImage = UIImage(named: "YouTubeLogo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        let logoItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoItem
    }
    
    private func setupRightNavigationItems() {
        let windowSharingButton = UIBarButtonItem(image: UIImage(named: "windowSharingIcon"), style: .plain, target: self, action: #selector(windowSharingButtonTapped))
        let notificationButton = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButtonTapped))
        let searchButton = UIBarButtonItem(image: UIImage(named: "SearchIcon"), style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItems = [searchButton, notificationButton, windowSharingButton]
    }
    
    // MARK: - @objc
    
    @objc func windowSharingButtonTapped() {
        print(#function)
    }
    
    @objc func notificationButtonTapped() {
        print(#function)
    }
    
    @objc func searchButtonTapped() {
        print(#function)
    }
    
}
