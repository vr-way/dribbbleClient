//
//  LoginViewController.swift
//  DribbleAppTest
//
//  Created by vrway on 18/04/2017.
//  Copyright © 2017 vrway. All rights reserved.
//

import UIKit
import TextAttributes

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var userPasswordTextFiels: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func onTapButton(_ sender: UIButton) {

        if userNameTextField.text == "admin" && userPasswordTextFiels.text == "password" {
            print("all is OK")
        } else {
            print("wrong login|password ")

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewDisign()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewDisign() {

        loginButton.layer.cornerRadius = 30.0
        self.view.bringSubview(toFront: self.loginButton)
        let userNmaeAtributes = TextAttributes()

        userNmaeAtributes.foregroundColor = .white
        let userNamePlaceholder = NSAttributedString(string: "Username", attributes: userNmaeAtributes)
        let userPassPlaceholder = NSAttributedString(string: "Password", attributes: userNmaeAtributes)
        self.userNameTextField.attributedPlaceholder = userNamePlaceholder
        self.userPasswordTextFiels.attributedPlaceholder = userPassPlaceholder

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
