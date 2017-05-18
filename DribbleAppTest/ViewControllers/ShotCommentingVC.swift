

import UIKit

class ShotCommentingVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
      
    }
    var arrayOfCommentsData = ["item1","item2","3","item4","item5","item6","item","item","item","item","item"]
    
    
    fileprivate struct Const {
        static let identifier = "ShotCommentId"
        static let cellNib = "ShotCell"
        static let xibName = "ShotCommentingViewCellTableViewCell"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
      

        self.commentTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
       
        return 5
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ShotCommentId", for: indexPath) as! ShotCommentingViewCell
        
    
        
        return cell
    }
    

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
        })
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //TODO:        self.tableView.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    
    
    

}
