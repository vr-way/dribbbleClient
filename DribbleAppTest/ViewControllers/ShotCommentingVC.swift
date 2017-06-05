import UIKit


class ShotCommentingVC: UIViewController  {

    @IBOutlet weak var sortCommentConstrain: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func reverseButtonPressed(_ sender: UIButton) {
        self.arrayOfCommentsData.reverse()
        self.tableView.reloadData()
    }
    @IBAction func postButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)

    }
    
    
    fileprivate var arrayOfCommentsData = [DribbleFeedComments ]()
    fileprivate let alertNoComments = UIAlertController(title: "Ooups", message: "There isn`t any commets to this shot.", preferredStyle: UIAlertControllerStyle.alert)

    fileprivate struct Const {
        static let identifier = "ShotCommentId"
        static let cellNib = "ShotCell"
        static let xibName = "ShotCommentingViewCellTableViewCell"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        title = "Comments"
        
        
        alertNoComments.addAction(UIAlertAction(title: "Be first!", style: UIAlertActionStyle.default, handler: nil))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        self.commentTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self

        let nib = UINib(nibName: Const.xibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Const.identifier)

        self.tableView.estimatedRowHeight = 2
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let shotId = MySingleton.shared.shotId
        fetchComments(shotID: shotId)
    }


   

    func fetchComments(shotID: String) {

        DribbbleServises.instance.getComment(shotId: shotID, successCallback: { [weak self] comments in
            guard let `self` = self else { return }

            self.arrayOfCommentsData += comments
                if self.arrayOfCommentsData.isEmpty {
                    print("array is empty")
                    self.present(self.alertNoComments, animated: true, completion: nil)
                } else {
                    self.sortCommentConstrain.constant += 55
                }

            self.tableView.reloadData()
      }, errorCallback: { error in
        print(error)
      })

    }

}


//MARK: Table view delegate
extension ShotCommentingVC: UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        commentTextField.resignFirstResponder()
    }
}

//MARK: Table view datasource 
extension ShotCommentingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //TODO: return your view
        return nil
    }
    
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
        
       
            var userInfo = notification.userInfo!
            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
            let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
            self.bottomConstraint.constant += changeInHeight
            UIView.animate(withDuration: 1) {
                    self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30)) {
                let lastIndex = IndexPath(row: self.arrayOfCommentsData.count - 1, section: 0)
                self.tableView.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: true)
            }
    }
        
    
}

