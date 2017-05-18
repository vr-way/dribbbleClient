import Foundation
import SwiftyJSON
import SDWebImage



class MySingleton {
    static let shared = MySingleton()
    var animateFlag = false
    var HDImageFlag =  true
}


struct DribbbleFeedItem {

    let shotUrl: URL?
    let likes: UInt
    let author: String
    let authorAvatarURL: URL?
    let description: String
    let title: String
    let animated: Bool
    let shotId: String
    
}
struct UserId {
    let id: UInt
    let Name: String
    let Username: String
    let html_url: URL?
    let avatar: URL?
    let bio: String
    let location: String
    
    
}



func mapDribbbleFeedItem(_ input: JSON) -> DribbbleFeedItem? {


    let title = input["title"].stringValue
    let description = input["description"].stringValue
    let likesCount = input["likes_count"].stringValue
    let authorName = input["user", "username"].stringValue
    let authorAvatarURL : URL = URL(string:   input["user","avatar_url"].stringValue)!
    let shotImageURL : URL = getHDImage(input: input)
    let likesCountUInt = UInt(likesCount)!
    let animatedImage = input["animated"].bool
    let id = input["id"].stringValue
    
    let item = DribbbleFeedItem(shotUrl: shotImageURL, likes: likesCountUInt, author: authorName, authorAvatarURL: authorAvatarURL, description: description, title: title, animated: animatedImage!, shotId: id)
    
    if MySingleton.shared.animateFlag{
        return item
    } else {
        return item.animated ? nil :  item
    }
    
    

}



func getHDImage(input: JSON) -> URL {
    var url: URL
    
    if MySingleton.shared.HDImageFlag {
    
    url = input["images","hidpi"] != JSON.null ? URL(string: input["images","hidpi"].stringValue)! : URL(string: "http://www.daaddelhi.org/imperia/md/content/newdelhi/b_no_image_icon.gif")!
    } else {
       url = URL(string: input["images","teaser"].stringValue)!
    }
 return url
    
}
