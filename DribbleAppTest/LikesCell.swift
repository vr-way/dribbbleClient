
import UIKit
import DribbbleSwift
import SDWebImage

class LikesCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var label: UILabel!

    func setData(_ data: DribbbleSwift.UserLikesDS ) {

        userAvatar.sd_setImage(with: URL(string: data.shot.user.avatar_url))
        userName.text = data.shot.user.name
        label.text = "Liked shot: \(data.shot.title!)"

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
