

import UIKit
import DribbbleSwift
import OAuthSwift

class LoginOauthViewController: UIViewController {
    
    var oauthswift: OAuthSwift?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        doOAuthDribbble()
    }
    
    func doOAuthDribbble(){
        let oauthswift = OAuth2Swift(
            consumerKey:    "14e6ca1e128d872a73309a71751416f2e36b513060e63a90e0301b35501124c6",
            consumerSecret: "66f0d84616538c0537014e70c13e84d6703d262782b89cc8ea4a8f8d83250112",
            authorizeUrl:   "https://dribbble.com/oauth/authorize",
            accessTokenUrl: "https://dribbble.com/oauth/token",
            responseType:   "code"
        )
        self.oauthswift = oauthswift
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = OAuthSwiftOpenURLExternally.sharedInstance
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "dribbleApp://oauth-callback/dribbble")!, scope: "", state: "",
            success: { credential, response, parameters in
                self.showTokenAlert(name: "Dribbble", credential: credential)
                // Get User
                let parameters =  [String: Any]()
                let _ = oauthswift.client.get(
                    "https://api.dribbble.com/v1/user?access_token=\(credential.oauthToken)", parameters: parameters,
                    success: { response in
                        let jsonDict = try? response.jsonObject()
                        print(jsonDict as Any)
                },
                    failure: { error in
                        print(error)
                })
        },
            failure: { error in
                print(error.description)
        })
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        self.showAlertView(title: name ?? "Service", message: message)
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  

}
