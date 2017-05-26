//
//  LoginOauthViewController.swift
//  DribbleAppTest
//
//  Created by vrway on 22/05/2017.
//  Copyright © 2017 vrway. All rights reserved.
//

import UIKit
import DribbbleSwift
import OAuthSwift

class LoginOauthViewController: UIViewController {
    @IBOutlet weak var myWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let url = URL (string: "http://www.dribbble.com/oauth/authorize");
//        let requestObj = URLRequest(url: url!);
//        myWebView.loadRequest(requestObj);
        //ConfigDS.setOAuth2Token(<#T##token: String##String#>)

        let oauthswift = OAuth2Swift(
            consumerKey:    "14e6ca1e128d872a73309a71751416f2e36b513060e63a90e0301b35501124c6",
            consumerSecret: "66f0d84616538c0537014e70c13e84d6703d262782b89cc8ea4a8f8d83250112",
            authorizeUrl:   "https://dribbble.com/oauth/authorize",
            responseType:   "token"
        )
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/dribble")!,
            scope: "comment", state:"dribbble",
            success: { credential, _, _ in
                print(credential.oauthToken)
        },
            failure: { error in
                print(error.localizedDescription)
        }
        )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
