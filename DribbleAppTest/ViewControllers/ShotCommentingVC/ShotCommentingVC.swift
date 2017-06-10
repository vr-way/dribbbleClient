import UIKit

class ShotCommentingVC: UIViewController  {
    
    @IBOutlet weak var sortCommentConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        postComment(comment: commentTextField.text)
        self.commentTextField.text = ""
    }
    @IBAction func txtFldEdittingChange(_ sender: UITextField) { postButton.isEnabled = true }
    
    @IBAction func textFieldTouchDown(_ sender: UITextField) {
        if !DribbbleServises.instance.isUserSignUp{
            showAlert(title: "Warning!", message: "The authorization is required. User must also be a player or team." , button: "OK")
        }
    }
    
    
    fileprivate var arrayOfCommentsData = [DribbleFeedComments ]()
    
    fileprivate struct Const {
        static let identifier = "ShotCommentId"
        static let cellNib = "ShotCell"
        static let xibName = "ShotCommentingViewCellTableViewCell"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        
        self.commentTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: Const.xibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Const.identifier)
        
        self.tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let shotId = buffer.shared.shotId
        fetchComments(shotID: shotId, scrollDown: false)
        
        
    }
    
    
    
    
    var pageNum = 0
    var firstEnter = true
    
    func fetchComments(shotID: String, scrollDown: Bool) {
        
        DribbbleServises.instance.getComment(shotId: shotID, page: pageNum, successCallback: { [weak self] comments in
            guard let `self` = self else { return }
            self.arrayOfCommentsData += comments
            
            
            if comments.count == 12 {
                self.pageNum += 1; self.fetchComments(shotID: shotID, scrollDown: scrollDown)
            } else {
                self.tableView.reloadData()
            }
            
            if scrollDown { self.scrollDown(delay: 300)}
            
            if self.firstEnter && self.arrayOfCommentsData.isEmpty {
                self.firstEnter = false
                self.showAlert(title: "Ooups", message: "There isn`t any commets to this shot.", button: "Be first!")
            }
            }, errorCallback: { error in
                print("error")
        })
        
    }
    
    var noAnimateCells = false
    
    func postComment(comment: String?){
        
        
        if comment != nil {
            
            DribbbleServises.instance.postComment(comment: comment!, id: buffer.shared.shotId){ [weak self] result in
                switch (result) {
                case .success:
                    self?.pageNum = 0
                    self?.arrayOfCommentsData = [DribbleFeedComments ]()
                    self?.fetchComments(shotID: buffer.shared.shotId, scrollDown: true)
                    
                case .error(let error):
                    
                    DribbleAPIErrorHandler.handleDribbleError(error: error)
                }
            }
        }
    }
    
    func showAlert(title : String, message: String, button: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .default) { action in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}




//MARK: Table view delegate
extension ShotCommentingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        commentTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.noAnimateCells{
            let dergree: Double = 90
            let rotationAngle = CGFloat(dergree * M_PI / 180)
            let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 1, 0)
            
            cell.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.2, delay: 0.02 * Double(indexPath.row),  animations: {
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
}

//MARK: Table view datasource
extension ShotCommentingVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCommentsData.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.identifier, for: indexPath) as! ShotCommentingViewCell
        if !arrayOfCommentsData.isEmpty {
            let dataItem = arrayOfCommentsData[indexPath.row]
            cell.setCommentData(dataItem)
            
            
        }
        return cell
    }
    
    
    
    
    
    
    
}

//MARK: UITextFieldDelegate && KeyBoard is Shown
extension ShotCommentingVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return DribbbleServises.instance.isUserSignUp
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: Notification) {
        adjustingHeight(show: true, notification: notification )
    }
    
    func keyboardWillHide(notification: Notification) {
        adjustingHeight(show: false, notification: notification )
    }
    
    func adjustingHeight(show: Bool, notification: Notification) {
        noAnimateCells = true
        var userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        self.bottomConstraint.constant += changeInHeight
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        
        self.scrollDown(delay: 30)
    }
    
    
    func scrollDown(delay: Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let lastIndex = IndexPath(row: (self.arrayOfCommentsData.count) - 1, section: 0)
            if  !(self.arrayOfCommentsData.isEmpty){
                self.tableView.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
}



