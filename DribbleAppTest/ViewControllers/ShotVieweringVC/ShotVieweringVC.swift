

import UIKit


class ShotVieweringVC:  UITableViewController{
    
   
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        if  !MySingleton.shared.settingsButtonPressed {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpId") as! PopUpViewController
            self.addChildViewController(popOverVC)
            popOverVC.view.frame =  self.tableView.frame
            self.tableView.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
        
        MySingleton.shared.settingsButtonPressed = true
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
    
    
    func refreshInvoked(_ sender:AnyObject) {
        sender.beginRefreshing()
        pageNum = 0
       // arrayOfCellData.removeAll()
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

    
 
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfCellData.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
     return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let cell =  tableView.dequeueReusableCell(withIdentifier: Const.identifier, for: indexPath) as! ShotViewCell
    
        let dataItem = arrayOfCellData[indexPath.section]
        cell.setData(dataItem)
        cell.onLabelTap = { _ in
            
            let shotCommentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
            self.navigationController?.pushViewController(shotCommentsVC, animated: true)
            
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let DestinationVC : ShotVieweringVC = segue.destination as! ShotVieweringVC
//        let shotId =  arrayOfCellData[0].shotId
//        
//       
//        
//    }
 
    
  
 
    
}
