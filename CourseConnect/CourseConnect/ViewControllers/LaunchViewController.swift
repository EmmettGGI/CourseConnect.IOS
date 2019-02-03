//
//  LaunchViewController.swift
//  CourseConnect
//
//  Created by Emmett Deen on 2/2/19.
//  Copyright © 2019 Emmett Deen. All rights reserved.
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.performSegue(withIdentifier: "Launch->Login", sender: self)
        
        let email = UserDefaults.standard.string(forKey: "email")
        let password = UserDefaults.standard.string(forKey: "password")
        
        
        
        if(email == nil || password == nil || (email?.count)! <= 0 || (password?.count)! <= 0){
            self.performSegue(withIdentifier: "Launch->Login", sender: self)
        }else{
            Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, err) in
                
                if(err != nil){
                    self.performSegue(withIdentifier: "Launch->Login", sender: self)
                }else{
                    
                    guard let user = authResult?.user else { return }
                    
                    //UserDefaults.standard.set(self.emailField.text, forKey: "email")
                    //UserDefaults.standard.set(self.passwordField.text, forKey: "password")
                    
                    if(user.isEmailVerified){
                        self.performSegue(withIdentifier: "Launch->Home", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "Launch->Login", sender: self)
                    }
                }
            }
        }
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
