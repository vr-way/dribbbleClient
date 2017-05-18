//
//  ShotCommentingViewCellTableViewCell.swift
//  DribbleAppTest
//
//  Created by vrway on 18/05/2017.
//  Copyright © 2017 vrway. All rights reserved.
//

import UIKit

class ShotCommentingViewCell: UITableViewCell {

    
    @IBOutlet weak var userAvatar: UIImageView!
    
    
    @IBOutlet weak var userNickname: UILabel!
    
    @IBOutlet weak var timeOfPost: UILabel!
    
    @IBOutlet weak var commentLable: UILabel!
    
    
    
    
    
    
    
    
    
    
    
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
