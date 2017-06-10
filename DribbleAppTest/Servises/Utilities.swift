import Foundation
import UIKit

func removeHtmlTags(string: String) -> String {
    
    var string = string; string = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    let characters = ["&#8217;": "'", "&#8220;": "“", "[&hellip;]": "...", "&#038;": "&", "&#8230;": "...", "&amp;": "&", "&quot;":"'", "&lt;":"<"]
    for (code, character) in characters {
        string = string.replacingOccurrences(of: code, with: character, options: .caseInsensitive, range: nil)
    }
    
    return string
}


func timePastFrom (dateFromJSON: String) -> String {
    var hours: Int
    var minutes: Int
    
    var  dateOfPost = dateFromJSON.replacingOccurrences(of: "T", with: " ")
    dateOfPost.remove(at: dateFromJSON.index(before: dateFromJSON.endIndex))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    var  dateFromString = dateFormatter.date(from: dateOfPost)
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    
    
    if dateFromString != nil {
        
        hours  = Int((dateFromString?.timeIntervalSinceNow)!) / 3600
        hours += secondsFromGMT / 3600
        minutes = Int((dateFromString?.timeIntervalSinceNow)!) / 60
        minutes += secondsFromGMT / 60
        
        
        if hours > 0 {
            return "Ooups, post from future ;)"
        } else if hours == -1 {
            return "about \(abs(hours)) hour ago"
        } else if hours == 0 && minutes < 0 {
            return "about \(abs(minutes)) minutes ago"
        } else if minutes == 0 {
            return "less than a minute ago"
        }
        else {
            return "about \(abs(hours)) hours ago"
        }
    } else {
        return "Sorry, we don`t know date of the post :("
    }
}



extension UIApplication {
    static var topViewController: UIViewController? {
        return UIApplication.shared.topViewController
    }
    
    var topViewController: UIViewController? {
        guard let rootController = self.keyWindow?.rootViewController else {
            return nil
        }
        return UIViewController.topViewController(rootController)
    }
}

extension UIViewController {
    
    static func topViewController(_ viewController: UIViewController) -> UIViewController {
        guard let presentedViewController = viewController.presentedViewController else {
            return viewController
        }
        
        if let navigationController = presentedViewController as? UINavigationController {
            if let visibleViewController = navigationController.visibleViewController {
                return topViewController(visibleViewController)
            }
        } else if let tabBarController = presentedViewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return topViewController(selectedViewController)
            }
        }
        
        return topViewController(presentedViewController)
    }
}



func singIn(flag: Bool){
    if flag{
        DribbbleServises.instance.isUserSignUp = true
        DribbbleServises.instance.keychain.set(true, forKey:"UserSignUpKey")
    } else {
        DribbbleServises.instance.isUserSignUp = false
        DribbbleServises.instance.keychain.set(false, forKey:"UserSignUpKey")
        DribbbleServises.instance.oauthUserToken = ""
        DribbbleServises.instance.keychain.set("", forKey:"outhUserTokenKeyChain")
    }
    
    
}


class buffer {
    static let shared = buffer()
    var animateFlag = false
    var HDImageFlag =  true
    var settingsButtonPressed = false
    var shotId = ""
    var userNickname = ""
}




