

import UIKit

class PopUpViewController: UIViewController {

    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var hdSegmentalControl: UISegmentedControl!
    @IBOutlet weak var gifSegmentalControl: UISegmentedControl!
    @IBAction func closePopUp(_ sender: UIButton) {
        hideWithAnimation()
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
        showAnimate()
    }

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1
        })

    }

    func hideWithAnimation() {

        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        }, completion: {(finished: Bool) in
        if finished {
            self.view.removeFromSuperview()
            }
        })

    }

}
