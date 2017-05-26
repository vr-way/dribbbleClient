

import UIKit
import SDWebImage
import TextAttributes

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
    
    var onLabelTap: (()->Void)?
    
    
    
    func setData(_ data: DribbbleFeedItem) {
        
        let formatStringToDescription = stringFromHtml(string: data.description)
      
      
        mainLabelText.text = data.title
        descriptionUnderText.attributedText = formatStringToDescription
        authorName.text = data.author
        
        MySingleton.shared.userNickname = data.author
        
        likeCounter.text = String(data.likes)
        authorAvatar.sd_setImage(with: data.authorAvatarURL)
        mainViewImage.sd_setImage(with: data.shotUrl, placeholderImage: UIImage(named: "shotIsLoading"))
        
        setAttributes(formatStringToDescription!)

        self.viewTitleCancas.isHidden = data.description.characters.count == 0 ? true : false
        
    }
    
    
    private func setAttributes(_ string: NSAttributedString){
        
        
        let i = NSMutableAttributedString(attributedString: string)
        let descriptionAttributes = TextAttributes()
        
        descriptionAttributes.foregroundColor = .white
        descriptionAttributes.font(name: "Arial", size: 14)
        
        i.addAttributes(descriptionAttributes)
   
        self.descriptionUnderText.attributedText = i
        
    
        
    }
    
    
    
   private  func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return  str
            }
        } catch {
        }
        return nil
    }

    private func setImgeURL(_ url: URL) {
     
        mainViewImage.sd_setImage(with: url)
    }
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
   
        if (authorName) != nil {
            
            self.authorName.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_ : )))
            tap.numberOfTapsRequired = 1
            self.authorName.addGestureRecognizer(tap)
            
        }
        
        selectionStyle = .none
        if (authorAvatar) != nil{
            let minSide = min(authorAvatar.bounds.width, authorAvatar.bounds.height)
            authorAvatar.layer.cornerRadius = minSide/2
            authorAvatar.clipsToBounds = true
        }
        
    }
    
    
    
    func doubleTapped(_ sender: UITapGestureRecognizer) {
      
        //TODO: передать переменную data.author
       
        onLabelTap!()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       // print("selected")
    }
    
}

