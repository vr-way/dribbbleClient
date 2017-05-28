

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var hdSegmentalControl: UISegmentedControl!
    @IBOutlet weak var gifSegmentalControl: UISegmentedControl!
    @IBAction func closePopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        MySingleton.shared.settingsButtonPressed = false
    }
    @IBAction func hdSegmentalControlAction(_ sender: UISegmentedControl) {
        MySingleton.shared.HDImageFlag = hdSegmentalControl.selectedSegmentIndex == 0 ? true : false
    }
    @IBAction func gifSegmentalControlAction(_ sender: UISegmentedControl) {
        MySingleton.shared.animateFlag = gifSegmentalControl.selectedSegmentIndex == 0 ? true : false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let bgColor = UIColor.black
        let semi = bgColor.withAlphaComponent(0.8)
        self.view.backgroundColor = semi
        self.viewContainer.layer.cornerRadius = 10

        hdSegmentalControl.selectedSegmentIndex =  MySingleton.shared.HDImageFlag == true ? 0 : 1
        gifSegmentalControl.selectedSegmentIndex =  MySingleton.shared.animateFlag == true ? 0 : 1
        
        
        self.backgroundView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToClose(_ : )))
        tap.numberOfTapsRequired = 1
        self.backgroundView.addGestureRecognizer(tap)
        
    }
    func tapToClose(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }


   

}
