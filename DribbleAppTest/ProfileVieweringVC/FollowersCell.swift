//
//  FollowersCell.swift
//  DribbleAppTest
//
//  Created by vrway on 23/05/2017.
//  Copyright © 2017 vrway. All rights reserved.
//

import UIKit
import DribbbleSwift
import SDWebImage

class FollowersCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numOfLikes: UILabel!
    
    
    func setData(_ data : DribbbleSwift.FollowersDS ){
       // print( data)
        userAvatar.sd_setImage(with: URL(string: data.follower.avatar_url))
        userName.text = data.follower.name!
        numOfLikes.text = " Number of likes: \(data.follower.likes_count!)"
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        selectionStyle = .none
        if (userAvatar) != nil{
            let minSide = min(userAvatar.bounds.width, userAvatar.bounds.height)
            userAvatar.layer.cornerRadius = minSide/2
            userAvatar.clipsToBounds = true
        }
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    
   
}
