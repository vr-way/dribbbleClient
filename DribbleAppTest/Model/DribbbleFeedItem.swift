import Foundation
import SwiftyJSON
import SDWebImage



struct DribbbleFeedItem {

    let shotUrl: URL?
    var likes: UInt
    var likeButtonState: Bool
    let authorName: String
    let authotUsername: String
    let authorAvatarURL: URL?
    let description: String
    let title: String
    let animated: Bool
    let shotId: String
    

}


func mapDribbbleFeedItem(_ input: JSON) -> DribbbleFeedItem? {
    
   

    let title = input["title"].stringValue
    let description = input["description"].stringValue
    let likesCount = input["likes_count"].stringValue
    let likeButtonState = false
    let authorUsername = input["user", "username"].stringValue
    let authorName = input["user", "name"].stringValue
    let authorAvatarURL: URL = URL(string:   input["user", "avatar_url"].stringValue)!
    let shotImageURL: URL = getHDImage(input: input)
    let likesCountUInt = UInt(likesCount)!
    let animatedImage = input["animated"].bool
    let id = input["id"].stringValue

//    DribbbleServises.instance.checkIfShotIsLiked(id: id) { isLiked in
//        likeButtonState = isLiked
//    }
    
    let item = DribbbleFeedItem(shotUrl: shotImageURL, likes: likesCountUInt, likeButtonState: likeButtonState, authorName: authorName, authotUsername: authorUsername, authorAvatarURL: authorAvatarURL, description: description, title: title, animated: animatedImage!, shotId: id)

    if buffer.shared.animateFlag {
        return item
    } else {
        return item.animated ? nil :  item
    }

}

func getHDImage(input: JSON) -> URL {
    var url: URL
    //MARK:    Added the ability to select image quality. If the hidpi mode is on, then only pictures in HD are shown, where there is no picture in high quality, a stub is displayed (it is easily corrected for normal quality), when the mode is turned off, pictures of the lowest quality are displayed
    
    if buffer.shared.HDImageFlag {

    url = input["images", "hidpi"] != JSON.null ? URL(string: input["images", "hidpi"].stringValue)! : URL(string: "http://www.daaddelhi.org/imperia/md/content/newdelhi/b_no_image_icon.gif")!
    } else {
       url = URL(string: input["images", "teaser"].stringValue)!
    }
 return url

}
