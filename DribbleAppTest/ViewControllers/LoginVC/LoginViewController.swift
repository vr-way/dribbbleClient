
import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        DribbbleServises.instance.doOAuthDribbble {[weak self] result in
            switch (result) {
            case .success:
                self?.pushToShotViewController()
            case .error(let error):
                DribbleAPIErrorHandler.handleDribbleError(error: error)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 25
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   

    func pushToShotViewController() {
        let shotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shotViewController") as! ShotVieweringVC
        self.navigationController?.pushViewController(shotVC, animated: true)
    }
    
   
}
