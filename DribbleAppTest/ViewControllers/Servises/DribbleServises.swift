
import Foundation
import Alamofire
import SwiftyJSON

enum Result<T> {
    case success(T)
    case error(Error)
}

protocol DribbbleServisesProtocol {
    
    func login(callback: (Result<()>) -> Void)
    func getShotsFeed(url: String, successCallback: @escaping ([DribbbleFeedItem]) -> Void,  errorCallback: @escaping (Error) -> Void )
}

//struct Const {
//    static let dribbbleFeedAPI = "https://api.dribbble.com/v1/shots?access_token=9fa5d5a325bf433f2b0dd348a18c7e629740fb123d091970be44e88fe7e5559b"//9b"
//    
//    
//    static let jsonFile = ""
//}

struct Config {
    static let ACCESS_TOKEN = "&access_token=9fa5d5a325bf433f2b0dd348a18c7e629740fb123d091970be44e88fe7e5559b"
    static let SHOT_URL = "https://api.dribbble.com/v1/shots"
    static let POPULAR_URL = SHOT_URL + "?sort="
    static let RECENT_URL = SHOT_URL + "?sort=recent"
    static let GIF_URL = SHOT_URL + "?sort=&list=animated?per_page=3"
    static let REBOUNDS_URL = SHOT_URL + "?sort=&list=rebounds"
    static let TEAMS_URL = SHOT_URL + "?sort=&list=teams"
}


class DribbbleServises: DribbbleServisesProtocol {
    
    static let instance: DribbbleServises = DribbbleServises()
    private init() {}
    
    
    //MARK: public
    func login(callback: (Result<()>) -> Void) {
    }
    
    func getShotsFeed(url: String, successCallback: @escaping ([DribbbleFeedItem]) -> Void, errorCallback: @escaping (Error) -> Void ){
        getShotsJSON (url: url){ response in
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

    
    //MARK: private methods
    private func getShotsJSON(url: String, calback: @escaping (Result<JSON>) -> Void) {
        
       // let url = Config.POPULAR_URL + "&page=10" + Config.ACCESS_TOKEN
 
        
        Alamofire.request(url).responseJSON { response in
        
            if let jsonString = response.result.value {
                
               let json = JSON(jsonString)
               
                calback(.success(json))
            } else {
                let error = NSError(domain: "Couldn't get response", code: 501, userInfo: nil)
                //print(Config.SHOT_URL + "&pages=2" + Config.ACCESS_TOKEN)
                calback(.error(error))
            }
        }
        
    }
}




