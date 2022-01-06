//
//  MainTabBarController.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/07.
//

import UIKit

class MainTabBarController: UITabBarController {
    enum TabBarItemConfig: String {
        case home
        case discover
        
        var title: String {
            return self.rawValue.capitalizingFirstLetter()
        }
        var image: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house")
            case .discover:
                return UIImage(systemName: "magnifyingglass")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.delegate = self
    }
    
    func configure() {
        let homeBarItem = UITabBarItem(title: TabBarItemConfig.home.title, image: TabBarItemConfig.home.image, selectedImage: nil)
        let discoverBarItem = UITabBarItem(title: TabBarItemConfig.discover.title, image: TabBarItemConfig.discover.image, selectedImage: nil)
        let topicService = TransferService(networkService: NetworkService())
        let queryService = TransferService(networkService: NetworkService())
        let topicPhotoRepository = TopicPhotoInformationRepository(service: topicService)
        let topicPhotoUsecase = TopicPhotoInformationUsecase(repository: topicPhotoRepository)
        let queryRepository = QueryPhotoInformationRepository(service: queryService)
        let queryUsecase = QueryPhotoInformationUsecase(repository: queryRepository)
        let homeViewModel = HomeViewModel(usecase: topicPhotoUsecase)
        let discoverViewModel = DiscoverViewModel(usecase: queryUsecase)
        guard let homeViewController = self.storyboard?.instantiateViewController(identifier: HomeViewController.identifider, creator: { coder in
            return HomeViewController(coder: coder, viewModel: homeViewModel)
        }) else {
            fatalError("Failed to load HomeViewController from storyboard.")
        }
        guard let discoverViewController = self.storyboard?.instantiateViewController(identifier: DiscoverViewController.identifider, creator: { coder in
            return DiscoverViewController(coder: coder, viewModel: discoverViewModel)
        }) else {
            fatalError("Failed to load DiscoverViewController from storyboard.")
        }
        homeViewController.tabBarItem = homeBarItem
        discoverViewController.tabBarItem = discoverBarItem
        self.viewControllers = [homeViewController, discoverViewController]
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        PhotoLoader.shared.cancelAllOperation()
    }
}
