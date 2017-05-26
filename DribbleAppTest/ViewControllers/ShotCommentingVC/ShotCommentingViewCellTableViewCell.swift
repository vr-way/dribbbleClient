//
//  ShotCommentingViewCellTableViewCell.swift
//  DribbleAppTest
//
//  Created by vrway on 18/05/2017.
//  Copyright © 2017 vrway. All rights reserved.
//

import UIKit
import SDWebImage
import TextAttributes

//extension String {
//    func convertHtmlSymbols() throws -> String? {
//        guard let data = data(using: .utf8) else { return nil }
//        
//            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
//        
//        }
//    }

class ShotCommentingViewCell: UITableViewCell {

    
    @IBOutlet weak var userAvatar: UIImageView!
    
    
    @IBOutlet weak var userNickname: UILabel!
    
    @IBOutlet weak var timeOfPost: UILabel!
    
    @IBOutlet weak var commentLable: UILabel!
    
    
    
    func setCommentData(_ data: DribbleFeedComments) {
        
       
        
       // let formatStringToDescription = stringFromHtml(string: d)
        
        userNickname.text = data.userName
        timeOfPost.text = timeOf(dateFromJSON: data.date)
        commentLable.text  = decodeCharactersIn(string: data.body)
        userAvatar.sd_setImage(with: data.userAvatar)
        
       // setAttributes(formatStringToDescription!)
        
    }
    
    func timeOf (dateFromJSON: String) -> String {
        let hours : Int
        let minutes : Int
        
        var  dateOfPost = dateFromJSON.replacingOccurrences(of: "T", with: " ")
        dateOfPost.remove(at: dateFromJSON.index(before: dateFromJSON.endIndex))
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = DateFormatter.Style.long
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
    
    func decodeCharactersIn(string: String) -> String {
        var string = string; string = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let characters = ["&#8217;" : "'", "&#8220;": "“", "[&hellip;]": "...", "&#038;": "&", "&#8230;": "..."]
        for (code, character) in characters {
            string = string.replacingOccurrences(of: code, with: character, options: .caseInsensitive, range: nil)
        }
        return string
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if (userAvatar) != nil{
            let minSide = min(userAvatar.bounds.width, userAvatar.bounds.height)
            userAvatar.layer.cornerRadius = minSide/2
            userAvatar.clipsToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
