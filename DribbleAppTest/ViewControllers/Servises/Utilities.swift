

import Foundation

func removeHtmlTags(string: String) -> String {
    
    var string = string; string = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    let characters = ["&#8217;": "'", "&#8220;": "“", "[&hellip;]": "...", "&#038;": "&", "&#8230;": "...", "&amp;": "&", "&quot;":"'"]
    for (code, character) in characters {
        string = string.replacingOccurrences(of: code, with: character, options: .caseInsensitive, range: nil)
    }
    
    return string
}


func timePastFrom (dateFromJSON: String) -> String {
    let hours: Int
    let minutes: Int
    
    var  dateOfPost = dateFromJSON.replacingOccurrences(of: "T", with: " ")
    dateOfPost.remove(at: dateFromJSON.index(before: dateFromJSON.endIndex))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let  dateFromString = dateFormatter.date(from: dateOfPost)
    
    if dateFromString != nil {
        
        hours  = Int((dateFromString?.timeIntervalSinceNow)!) / 3600
        minutes = Int((dateFromString?.timeIntervalSinceNow)!) / 60
        
        if hours > 0 {
            return "Ooups, post from future ;)"
        } else if hours == -1 {
            return "about \(abs(hours)) hour ago"
        } else if hours == 0 {
            return "about \(abs(minutes)) minutes ago"
        } else {
            return "about \(abs(hours)) hours ago"
        }
    } else {
        return "Sorry, we don`t know date of the post :("
    }
}





