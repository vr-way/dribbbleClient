import UIKit

class ShotVieweringVC: UITableViewController {

    @IBOutlet weak var settingsButton: UIBarButtonItem!

    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        settingsTapHandler()
    }

  
    var arrayOfCellData: [DribbbleFeedItem] = []
    var loadMoreStatus = false
    var pageNum = 1

    fileprivate struct Const {
        static let identifier = "cellIdentifier"
        static let cellNib = "ShotCell"
    }

    
    
    override func viewDidLoad() {

        let nib = UINib(nibName: "ShotViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Const.identifier)
        loadShots(page: 1)

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl.addTarget(self, action: #selector(ShotVieweringVC.refreshInvoked(_:)), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfCellData.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =  tableView.dequeueReusableCell(withIdentifier: Const.identifier, for: indexPath) as! ShotViewCell
        let dataItem = arrayOfCellData[indexPath.section]
        cell.setData(dataItem)
        cell.onLabelTap = { _ in
            let shotCommentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
            self.navigationController?.pushViewController(shotCommentsVC, animated: true)
         
            MySingleton.shared.userNickname = self.arrayOfCellData[indexPath.section].authotUsername
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heigtCell = self.tableView.frame.height/2
        return heigtCell
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //super.scrollViewDidScroll(scrollView)

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset <= scrollView.frame.size.height * 2 {
        loadShots(page: pageNum)

        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let shotCommentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShotVC")
        navigationController?.pushViewController(shotCommentsVC, animated: true)
        let shotId =  arrayOfCellData[indexPath.section].shotId
        MySingleton.shared.shotId = shotId

    }

    private var settingsVC: PopUpViewController?
    private func settingsTapHandler(){
//        if let settings = settingsVC {
//            settings.dismiss(animated: true)
//            settingsVC = nil
//            return
//        }
//        
        
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpId") as! PopUpViewController
        
        popOverVC.modalTransitionStyle = .crossDissolve
        popOverVC.modalPresentationStyle = .overCurrentContext
        present(popOverVC, animated: true, completion: nil)
        
        settingsVC = popOverVC
    }
    
    func refreshInvoked(_ sender: AnyObject) {
        sender.beginRefreshing()
        pageNum = 0
        loadShots(page: 1)
        sender.endRefreshing()
    }
    
    func loadShots(page: Int) {
        if !loadMoreStatus {
            loadMoreStatus = true
            pageNum += 1
            DribbbleServises.instance.getShotsFeed(page: page, successCallback: {[weak self] feedItems in
                guard let `self` = self else { return }
                self.arrayOfCellData += feedItems
                self.tableView.reloadData()
                self.loadMoreStatus = false
                }, errorCallback: { error in
                    print(error)
            })
        }
    }

}
