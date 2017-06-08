import Foundation
import Alamofire
import SwiftyJSON
import OAuthSwift
import KeychainSwift


enum Result<T> {
    case success(T)
    case error(Error)
}

protocol DribbbleServisesProtocol {
    func getShotsFeed(page: Int, successCallback: @escaping ([DribbbleFeedItem]) -> Void, errorCallback: @escaping (Error) -> Void )
}



struct Config {
    static let ACCESS_TOKEN = "9fa5d5a325bf433f2b0dd348a18c7e629740fb123d091970be44e88fe7e5559b"
    static let CONSUMER_KEY  = "14e6ca1e128d872a73309a71751416f2e36b513060e63a90e0301b35501124c6"
    static let CONSUMER_SECRET = "66f0d84616538c0537014e70c13e84d6703d262782b89cc8ea4a8f8d83250112"
    
    static let SHOT_URL = "https://api.dribbble.com/v1/shots"
    static let POPULAR_URL = SHOT_URL + "?sort="
}

class DribbbleServises: DribbbleServisesProtocol {

  
    static let instance: DribbbleServises = DribbbleServises()
    private init() {}

// MARK: public

    func getShotsFeed(page: Int, successCallback: @escaping ([DribbbleFeedItem]) -> Void, errorCallback: @escaping (Error) -> Void ) {

        let url = Config.POPULAR_URL + "&page=" + String(page) + "&access_token=" + Config.ACCESS_TOKEN

        getJSON (url: url) { response in
            switch response {
            case .success(let result):
                guard let array = result.array else { return }
                let items =  array.flatMap { mapDribbbleFeedItem($0) }
                successCallback(items)
            case .error(let error):
                errorCallback(error)
            }
        }
    }

    func getComment(shotId: String, page: Int, successCallback: @escaping ([DribbleFeedComments]) -> Void, errorCallback: @escaping (Error) -> Void ) {

      let url = Config.SHOT_URL + "/" + shotId + "/comments?page=" + String(page) + "&access_token=" + Config.ACCESS_TOKEN

        getJSON (url: url) { response in
            switch response {
            case .success(let result):
                guard let array = result.array else { return }
                let items =  array.flatMap { mapDribbleFeedComments($0) }
                successCallback(items)
            case .error(let error):
                errorCallback(error)
            }
        }
    }

    
//MARK: likeShot
    func likeShot(id:String) {
        
       
        
        if !oauthUserToken.isEmpty{
            
            Alamofire.request("https://api.dribbble.com/v1/shots/\(id)/like?access_token=\(self.oauthUserToken)", method:.post).responseJSON
        } else {
            print ("need signUP")
        }
        
       
    }
    
    
    func dislikeShot(id: String){
        if !oauthUserToken.isEmpty{
            Alamofire.request("https://api.dribbble.com/v1/shots/\(id)/like?access_token=\(self.oauthUserToken)", method:.delete)
           
        }
    }
    
    func checkIfShotIsLiked(id: String, callback: @escaping (_ isLiked: Bool) -> Void) -> DataRequest {
        
        let req = Alamofire.request("https://api.dribbble.com/v1/shots/\(id)/like?access_token=\(self.oauthUserToken)", method:.get).responseJSON { response in
            
            if response.result.value != nil{
               callback(true)
            } else {
               callback(false)
            }
        }
        return req
    }
    
    
    
//MARK: postComment

    
    func postComment(comment: String, id: String, callback: @escaping (Result<()>) -> Void = { _ in }) {
        
    
        
        let urlString = "https://api.dribbble.com/v1/shots/\(id)/comments?access_token=\(self.oauthUserToken)"
        
        Alamofire.request(urlString, method: .post, parameters: ["body": comment],encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                  callback(Result.success())
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    
// MARK: private methods
    private func getJSON(url: String, calback: @escaping (Result<JSON>) -> Void) {

        Alamofire.request(url).responseJSON { response in

            if let jsonString = response.result.value {

               let json = JSON(jsonString)

                calback(.success(json))
            } else {
                let error = NSError(domain: "Couldn't get response", code: 501, userInfo: nil)
                calback(.error(error))
            }
        }

    }

//MARK: Authorization
    var oauthswift: OAuthSwift?
    var oauthUserToken = String()
    var isUserSignUp =  false
    let keychain = KeychainSwift()
    
    func doOAuthDribbble(callback: @escaping (Result<()>) -> Void = { _ in }){
        let oauthswift = OAuth2Swift(
            consumerKey:    Config.CONSUMER_KEY,
            consumerSecret: Config.CONSUMER_SECRET,
            authorizeUrl:   "https://dribbble.com/oauth/authorize",
            accessTokenUrl: "https://dribbble.com/oauth/token",
            responseType:   "code"
        )
        
        self.oauthswift = oauthswift
        oauthswift.allowMissingStateCheck = true
        
        let authVC = AuthentificationNVC(title: "Dribble")
        oauthswift.authorizeURLHandler = authVC
        
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "dribbleApp://oauth-callback/dribbble")!, scope: "public+write+comment", state: "",
            success: { credential, response, parameters in
                self.oauthUserToken = credential.oauthToken
                self.isUserSignUp = true
                self.keychain.set(credential.oauthToken, forKey:"outhUserTokenKeyChain")
                self.keychain.set(true, forKey:"UserSignUpKey")
                 
                callback(Result.success())
                
                authVC.dismiss(animated: true, completion: nil)
                
        },
            failure: { error in
                callback(Result.error(error))
                self.isUserSignUp = false
                authVC.dismiss(animated: true, completion: nil)
                print(error.description)
        })

    }
    
  
   
    
}
