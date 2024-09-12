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
    var isDarkMode = false
    var automaticMode = true
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let podcastEnterViewController = PodcastEnterViewController(viewModel: PodcastEnterViewModel())
        
        let navigationController = UINavigationController(rootViewController: podcastEnterViewController)
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
        applyAppearance()
        
        return true
    }
    
    func applySystemModeAppearance() {
        window?.overrideUserInterfaceStyle = .unspecified
        automaticMode = true
        UserDefaults.standard.removeObject(forKey: "darkMode")
    }
    
    func applyDarkModeAppearance() {
        window?.overrideUserInterfaceStyle = .dark
        UserDefaults.standard.set(true, forKey: "darkMode")
        automaticMode = false
    }
    
    func applyLightModeAppearance() {
        
        window?.overrideUserInterfaceStyle = .light
        UserDefaults.standard.set(false, forKey: "darkMode")
        automaticMode = false
    }
    
    func loadAppearancePreference() {
        isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")
        applyAppearance()
    }
    
    func applyAppearance() {
        if automaticMode {
            return
        }
        if isDarkMode {
            window?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: "darkMode")
        } else {
            window?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(false, forKey: "darkMode")
        }
    }
}

