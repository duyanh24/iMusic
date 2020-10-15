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
    case playlistDetail(playlist: String)
    case createPlaylist
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .tabbar:
            let rootTabbarController = RootTabbarController.instantiate()
            
            let homeViewModel = HomeViewModel()
            let homeServices = HomeServices(trackService: TrackService(), userService: UserService())
            let homeViewController = HomeViewController.instantiate(withViewModel: homeViewModel, andServices: homeServices)
            let homeNavController = BaseNavigationController(rootViewController: homeViewController)
            let homeTabbarItem = UITabBarItem(title: Strings.home, image: Asset.tabbarButtonDiscoverNormalNormal.image, selectedImage: Asset.tabbarButtonDiscoverSelectedNormal.image)
            homeNavController.tabBarItem = homeTabbarItem
            
            let searchViewModel = SearchViewModel()
            let searchViewController = SearchViewController.instantiate(withViewModel: searchViewModel)
            let searchNavController = BaseNavigationController(rootViewController: searchViewController)
            let searchTabbarItem = UITabBarItem(title: Strings.search, image: Asset.icSearchBlackNormal.image, selectedImage: Asset.icSearchBlackNormal.image)
            searchNavController.tabBarItem = searchTabbarItem
            
            let mypageViewModel = MypageViewModel()
            let mypageServices = MypageServices(playlistService: PlaylistService(), trackService: TrackService())
            let mypageViewController = MypageViewController.instantiate(withViewModel: mypageViewModel, andServices: mypageServices)
            let mypageNavController = BaseNavigationController(rootViewController: mypageViewController)
            let moreTabbarItem = UITabBarItem(title: Strings.profile, image: Asset.tabbarButtonPersonalNormalNormal.image, selectedImage: Asset.tabbarButtonPersonalSelectedNormal.image)
            mypageNavController.tabBarItem = moreTabbarItem
            
            let settingViewModel = SettingViewModel()
            let settingViewController = SettingViewController.instantiate(withViewModel: settingViewModel)
            let settingNavController = BaseNavigationController(rootViewController: settingViewController)
            let settingTabbarItem = UITabBarItem(title: Strings.settings, image: Asset.tabbarSettingsNormalNormal.image, selectedImage: Asset.tabbarSettingsSelectedNormal.image)
            settingNavController.tabBarItem = settingTabbarItem
            
            rootTabbarController.viewControllers = [homeNavController, searchNavController, mypageNavController, settingNavController]
            return .tabBar(rootTabbarController)
        case .splash:
            let splashViewModel = SplashViewModel()
            let splashServices = SplashServices(authencationService: AuthencationService())
            let splashViewController = SplashViewController.instantiate(withViewModel: splashViewModel, andServices: splashServices)
            return .root(splashViewController)
            
        case .login:
            let loginViewModel = LoginViewModel()
            let loginServices = LoginServices(authencationService: AuthencationService())
            let loginViewController = LoginViewController.instantiate(withViewModel: loginViewModel, andServices: loginServices)
            return .root(loginViewController)
            
        case .playlistDetail(let playlist):
            let playlisDetailViewModel = PlaylisDetailViewModel(playlist: playlist)
            let mypageServices = MypageServices(playlistService: PlaylistService(), trackService: TrackService())
            let playlistDetailViewController = PlaylistDetailViewController.instantiate(withViewModel: playlisDetailViewModel, andServices: mypageServices)
            return .push(playlistDetailViewController)
            
        case .createPlaylist:
            let createPlaylistViewModel = CreatePlaylistViewModel()
            let mypageServices = MypageServices(playlistService: PlaylistService(), trackService: TrackService())
            let createPlaylistViewController = CreatePlaylistViewController.instantiate(withViewModel: createPlaylistViewModel, andServices: mypageServices)
            return .present(createPlaylistViewController)
        }
    }
}
