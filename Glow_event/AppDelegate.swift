//
//  AppDelegate.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 25/11/2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
import Cloudinary

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var cloudinary: CLDCloudinary!
    //var isInRegistrationFlow = false // Flag to track registration/login state
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = createEventVC()
        let navigationController = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let config = CLDConfiguration(cloudName: "your_cloud_name", apiKey: "your_api_key", apiSecret: "your_api_secret")
        cloudinary = CLDCloudinary(configuration: config)
        
        
        FirebaseApp.configure()
        
        requestNotificationPermissions()
        
        // Check notification authorization
        checkNotificationAuthorization()
        
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func checkNotificationAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notification permission granted.")
            case .denied:
                print("Notification permission denied.")
            case .notDetermined:
                print("Notification permission not determined.")
            case .provisional:
                print("Provisional notification permission granted.")
            default:
                print("Unknown notification permission status.")
            }
        }
    }
    
    
    private func requestNotificationPermissions() {
        // Create the notification center
        let center = UNUserNotificationCenter.current()
        
        // Request authorization for alerts, sounds, and badges
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
                return
            }
            else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

    
