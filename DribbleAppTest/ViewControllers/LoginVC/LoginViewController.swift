//
//  LoginViewController.swift
//  DribbleAppTest
//
//  Created by vrway on 18/04/2017.
//  Copyright © 2017 vrway. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        DribbbleServises.instance.doOAuthDribbble {[weak self] result in
            switch (result) {
            case .success:
                self?.pushToShotViewController()
            case .error(let error):
                //TODO: show alert view for user
                DribbleAPIErrorHandler.handleDribbleError(error: error)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        viewApearence()
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
  


    private func viewApearence() {
        signUpButton.layer.cornerRadius = 25
    }
   

    func pushToShotViewController() {
        let shotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shotViewController") as! ShotVieweringVC
   
         self.navigationController?.pushViewController(shotVC, animated: true)
      

    }
    
   
}
