import UIKit
import SDWebImage


class ShotViewCell: UITableViewCell {

    @IBOutlet weak var mainViewImage: UIImageView!

    @IBOutlet weak var authorAvatar: UIImageView!

    @IBOutlet weak var mainLabelText: UILabel!

    @IBOutlet weak var descriptionUnderText: UILabel!

    @IBOutlet weak var likeCounter: UILabel!

    @IBOutlet weak var authorName: UILabel!

    @IBOutlet weak var viewTitleCancas: ShotViewCell!

    @IBAction func likeButton2(_ sender: UIButton) {

    }

    var onLabelTap: (() -> Void)?
    
    



    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        descriptionUnderText.text = decodeCharactersIn(string: data.description)
        authorName.text = data.author
        likeCounter.text = String(data.likes)
        authorAvatar.sd_setImage(with: data.authorAvatarURL)
        mainViewImage.sd_setImage(with: data.shotUrl, placeholderImage: UIImage(named: "shotIsLoading"))
        
        self.viewTitleCancas.isHidden = data.description.characters.count == 0 ? true : false
        
        MySingleton.shared.userNickname = data.author
    }
    
    
    
    
   
    
    
    func decodeCharactersIn(string: String) -> String {
        
        var string = string; string = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let characters = ["&#8217;": "'", "&#8220;": "“", "[&hellip;]": "...", "&#038;": "&", "&#8230;": "...", "&amp;": "&"]
        for (code, character) in characters {
            string = string.replacingOccurrences(of: code, with: character, options: .caseInsensitive, range: nil)
        }
        
        return string
    }


}
