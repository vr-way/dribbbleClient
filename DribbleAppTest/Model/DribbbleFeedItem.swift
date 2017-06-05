import Foundation
import SwiftyJSON
import SDWebImage

class MySingleton {
    static let shared = MySingleton()
    var animateFlag = false
    var HDImageFlag =  true
    var settingsButtonPressed = false
    var shotId = ""
    var userNickname = ""
}

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
    var likesCount = input["likes_count"].stringValue
    var likeButtonState = false
    let authorUsername = input["user", "username"].stringValue
    let authorName = input["user", "name"].stringValue
    let authorAvatarURL: URL = URL(string:   input["user", "avatar_url"].stringValue)!
    let shotImageURL: URL = getHDImage(input: input)
    let likesCountUInt = UInt(likesCount)!
    let animatedImage = input["animated"].bool
    let id = input["id"].stringValue

    let item = DribbbleFeedItem(shotUrl: shotImageURL, likes: likesCountUInt, likeButtonState: likeButtonState, authorName: authorName, authotUsername: authorUsername, authorAvatarURL: authorAvatarURL, description: description, title: title, animated: animatedImage!, shotId: id)

    if MySingleton.shared.animateFlag {
        return item
    } else {
        return item.animated ? nil :  item
    }

}

func getHDImage(input: JSON) -> URL {
    var url: URL
//MARK:   добавил возможность выбора качства изображения.  если режим  hidpi   включен, то показываются ТОЛЬКО  картинки в HD,  там где нет картинки в высоком качестве показывается заглушка ( легко исправляется на  качество normal), когда режим выключен показываются картинки самого низкого качества
    
    if MySingleton.shared.HDImageFlag {

    url = input["images", "hidpi"] != JSON.null ? URL(string: input["images", "hidpi"].stringValue)! : URL(string: "http://www.daaddelhi.org/imperia/md/content/newdelhi/b_no_image_icon.gif")!
    } else {
       url = URL(string: input["images", "teaser"].stringValue)!
    }
 return url

}
