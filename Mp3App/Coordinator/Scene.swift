//
//  Scene.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case splash
    case tabbar
    case login
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .tabbar:
            let rootTabbarController = RootTabbarController.instantiate()
            
            let homeViewModel = HomeViewModel()
            let homeServices = HomeServices(trackService: TrackService())
            let homeViewController = HomeViewController.instantiate(withViewModel: homeViewModel, andServices: homeServices)
            let homeNavController = BaseNavigationController(rootViewController: homeViewController)
            let homeTabbarItem = UITabBarItem(title: Strings.home, image: nil, selectedImage: nil)
            homeNavController.tabBarItem = homeTabbarItem
            
            let searchViewModel = SearchViewModel()
            let searchViewController = SearchViewController.instantiate(withViewModel: searchViewModel)
            let searchNavController = BaseNavigationController(rootViewController: searchViewController)
            let searchTabbarItem = UITabBarItem(title: Strings.search, image: nil, selectedImage: nil)
            searchNavController.tabBarItem = searchTabbarItem
            
            let mypageViewModel = MypageViewModel()
            let mypageViewController = MypageViewController.instantiate(withViewModel: mypageViewModel)
            let mypageNavController = BaseNavigationController(rootViewController: mypageViewController)
            let moreTabbarItem = UITabBarItem(title: Strings.more, image: nil, selectedImage: nil)
            mypageNavController.tabBarItem = moreTabbarItem
            
            let settingViewModel = SettingViewModel()
            let settingViewController = SettingViewController.instantiate(withViewModel: settingViewModel)
            let settingNavController = BaseNavigationController(rootViewController: settingViewController)
            let settingTabbarItem = UITabBarItem(title: Strings.settings, image: nil, selectedImage: nil)
            settingNavController.tabBarItem = settingTabbarItem
            
            rootTabbarController.viewControllers = [homeNavController, searchNavController, mypageNavController, settingNavController]
            return .tabBar(rootTabbarController)
        case .splash:
            let splashViewModel = SplashViewModel()
            let splashViewController = SplashViewController.instantiate(withViewModel: splashViewModel)
            return .root(splashViewController)
            
        case .login:
            let loginViewModel = LoginViewModel()
            let loginViewController = LoginViewController.instantiate(withViewModel: loginViewModel)
            return .root(loginViewController)
        }
    }
}
