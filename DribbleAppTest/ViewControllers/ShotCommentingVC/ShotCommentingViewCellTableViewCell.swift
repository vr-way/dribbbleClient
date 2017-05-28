
import UIKit
import SDWebImage


class ShotCommentingViewCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!

    @IBOutlet weak var userNickname: UILabel!

    @IBOutlet weak var timeOfPost: UILabel!

    @IBOutlet weak var commentLable: UILabel!

    
    
    
    func setCommentData(_ data: DribbleFeedComments) {
        userNickname.text = data.userName
        timeOfPost.text = timePastFrom(dateFromJSON: data.date)
        commentLable.text  = removeHtmlTags(string: data.body)
        userAvatar.sd_setImage(with: data.userAvatar)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        if (userAvatar) != nil {
            let minSide = min(userAvatar.bounds.width, userAvatar.bounds.height)
            userAvatar.layer.cornerRadius = minSide/2
            userAvatar.clipsToBounds = true
        }
    }

 

}
