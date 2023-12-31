//
//  AppDelegate.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit
import OHHTTPStubs
import OHHTTPStubsSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Stub API response
        #if DEBUG
        
        // Stub response pulsa items.
        stub(condition: pathEndsWith("/pulsa/items")) { _ in
            let stubPath = OHPathForFile("pulsa_items_response.json", type(of: self))
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }
        
        // Stub response voucher items.
        stub(condition: pathEndsWith("/voucher/items")) { _ in
            let stubPath = OHPathForFile("voucher_items_response.json", type(of: self))
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }
        
        // Stub response payment status page.
        stub(condition: pathEndsWith("/payment/status")) { _ in
            let stubPath = OHPathForFile("status_page_response.json", type(of: self))
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }
        
        #endif
        
        return true
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

