//
//  LogInViewController.swift
//  CourseConnect
//
//  Created by Emmett Deen on 2/2/19.
//  Copyright © 2019 Emmett Deen. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        errorLabel.text = ""
        if (emailField.text?.count)! > 0 && (passwordField.text?.count)! > 0{
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
                if error == nil{
                    self.performSegue(withIdentifier: "Login->Home", sender: self)
                    UserDefaults.standard.set(self.emailField.text!, forKey: "email")
                    UserDefaults.standard.set(self.passwordField.text!, forKey: "password")
                }else{
                    self.errorLabel.text = error?.localizedDescription
                }
            }
        }else{
            errorLabel.text = "Please fill out all the fields."
        }
    }
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        errorLabel.text = ""
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(){
        emailField.endEditing(true)
        passwordField.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
