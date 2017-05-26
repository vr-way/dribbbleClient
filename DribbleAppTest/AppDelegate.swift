//
//  AppDelegate.swift
//  DribbleAppTest
//
//  Created by vrway on 15.04.17.
//  Copyright © 2017 vrway. All rights reserved.
//

import UIKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "oauth-swift://oauth-callback/dribbble") {
            OAuthSwift.handle(url: url)
        }
        return true
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

    
        return true
    }
}

