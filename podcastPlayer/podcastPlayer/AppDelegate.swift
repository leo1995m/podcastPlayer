//
//  AppDelegate.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let podcastEnterViewController = PodcastEnterViewController(viewModel: PodcastEnterViewModel())
        
        let navigationController = UINavigationController(rootViewController: podcastEnterViewController)
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

