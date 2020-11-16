//
//  CreateUserViewController.swift
//  LoginApp
//
//  Created by Yali Sun on 11/15/20.
//

import UIKit
import Firebase
import SwiftSpinner

class CreateUserViewController : UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let email = txtEmail.text
        let password = txtPassword.text
        
        if email == "" || password!.count < 6 {
            lblStatus.text = "Please enter Email and correct Password"
            return
        }
        
        if email?.isEmail == false {
            lblStatus.text = "Please enter valid Email"
            return
        }
        
        SwiftSpinner.show("Creating new user...")
        Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
            SwiftSpinner.hide()
                    
            if(error != nil) {
                let casetedError = error! as NSError
                let firebaseError = casetedError.code
                self.lblStatus.text = "Error!"
                print("error： " + String(firebaseError) + error!.localizedDescription)
                return
            }
            self.lblStatus.text = "User successfully created"
        }
    }
}
