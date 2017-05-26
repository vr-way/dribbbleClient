

import UIKit

class ShotCommentingVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
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
    var arrayOfCommentsData = [DribbleFeedComments ]()
    let alertNoComments = UIAlertController(title: "Ooups", message: "There isn`t any commets to this shot.", preferredStyle: UIAlertControllerStyle.alert)
    
   
    
    fileprivate struct Const {
        static let identifier = "ShotCommentId"
        static let cellNib = "ShotCell"
        static let xibName = "ShotCommentingViewCellTableViewCell"
    }
    
   
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        
        
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrayOfCommentsData.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Const.identifier, for: indexPath) as! ShotCommentingViewCell
        if !arrayOfCommentsData.isEmpty{
        let dataItem = arrayOfCommentsData[indexPath.row]
        cell.setCommentData(dataItem)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//      //  var cell = tableView.cellForRow(at: indexPath)
//        return tableView.rowHeight = UITableViewAutomaticDimension
//    }
    
    

    func keyboardWillShow(notification:Notification) {
        print("keyboard is shown")
     adjustingHeight(show: true, notification: notification )
    }
    
    func keyboardWillHide(notification:Notification) {
        print("keyboard is hided")
       adjustingHeight(show: false, notification: notification )
    }
    
    func adjustingHeight(show:Bool, notification:Notification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        //TODO: set right timeout of animationDurarition
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height + 0) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
           // self.tableView.scrollToRowAtIndexPath(self.tableView.indexPath, atScrollPosition: .Top, animated: true)
            //self.tableView.scrollsToTop(changeInHeight)
             //tableView.setContentOffset(CGPointMake(0, textField.center.y-60), animated: true)
            //self.tableView.setContentOffset(60, animated: true)
            //self.tableView.scrollsToTop
        })
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        commentTextField.resignFirstResponder()
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
