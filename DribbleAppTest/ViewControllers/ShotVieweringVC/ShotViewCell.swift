import UIKit
import SDWebImage
import Alamofire

class ShotViewCell: UITableViewCell {

    @IBOutlet weak var mainViewImage: UIImageView!

    @IBOutlet weak var authorAvatar: UIImageView!

    @IBOutlet weak var mainLabelText: UILabel!

    @IBOutlet weak var descriptionUnderText: UILabel!

    @IBOutlet weak var likeCounter: UILabel!

    @IBOutlet weak var authorName: UILabel!

    @IBOutlet weak var viewTitleCancas: ShotViewCell!

    @IBAction func likeButton2(_ sender: UIButton) {
        
         onLikeTap!()
         //likeCounter.text = String(Int(likeCounter.text!)! + 1)
      
        
    }
    @IBOutlet weak var likeButtonOutlet: UIButton!

    var onLabelTap: (() -> Void)?
    var onLikeTap: (() -> Void)?
    
    private var likeReq: DataRequest?



    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // likeButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
        
        if likeButtonOutlet != nil {
            likeButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
            likeButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "like_pressed"), for: UIControlState.selected)
        }
        selectionStyle = .none
        
        if (authorName) != nil {
            self.authorName.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_ : )))
            tap.numberOfTapsRequired = 1
            self.authorName.addGestureRecognizer(tap)
        }

        
        if (authorAvatar) != nil {
            let minSide = min(authorAvatar.bounds.width, authorAvatar.bounds.height)
            authorAvatar.layer.cornerRadius = minSide/2
            authorAvatar.clipsToBounds = true
        }

    }
    
    func doubleTapped(_ sender: UITapGestureRecognizer) {
        
        //TODO: передать переменную data.author
        onLabelTap!()
        }

    
    func setData(_ data: DribbbleFeedItem) {
        
        mainLabelText.text = data.title
        descriptionUnderText.text = removeHtmlTags(string: data.description)
        authorName.text = data.authorName
        likeCounter.text = String(data.likes)
        authorAvatar.sd_setImage(with: data.authorAvatarURL)
        mainViewImage.sd_setImage(with: data.shotUrl, placeholderImage: UIImage(named: "shotIsLoading"))
        
        self.viewTitleCancas.isHidden = data.description.characters.count == 0 ? true : false
        
        
        
        
        if DribbbleServises.instance.isUserSignUp {
            likeReq = DribbbleServises.instance.checkIfShotIsLiked(id: data.shotId) {[weak self] isLiked in
                self?.likeButtonOutlet.isSelected = isLiked
            }
        } else {
            likeButtonOutlet.isSelected = false
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeReq?.cancel()
    }
}
