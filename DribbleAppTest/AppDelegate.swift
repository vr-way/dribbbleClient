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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        if DribbbleServises.instance.keychain.get("outhUserTokenKeyChain") != nil{
            DribbbleServises.instance.oauthUserToken = DribbbleServises.instance.keychain.get("outhUserTokenKeyChain")!
            DribbbleServises.instance.isUserSignUp = DribbbleServises.instance.keychain.getBool("UserSignUpKey")!
        }
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if   DribbbleServises.instance.keychain.getBool("UserSignUpKey") != nil  {
         window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainShotController")
        } else {
         window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultRootVC")
        }
        
        
       
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        
        

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }
        return true
    }
}
