//
//  SendPasswordResetViewController.swift
//  LoginApp
//
//  Created by Yali Sun on 11/15/20.
//

import UIKit
import Firebase

class SendPasswordResetViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func resetPasswordAction(_ sender: Any) {
        let email = txtEmail.text
        
        if !email!.isEmail {
            lblStatus.text = "Please enter valid email"
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email!) { error in
            if error != nil {
                self.lblStatus.text = "Sorry, reset failed"
            } else {
                self.lblStatus.text = "Check your email for link"
            }
        }
    }
}
