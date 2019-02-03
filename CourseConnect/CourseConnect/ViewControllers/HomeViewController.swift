//
//  HomeViewController.swift
//  CourseConnect
//
//  Created by Emmett Deen on 2/2/19.
//  Copyright © 2019 Emmett Deen. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bannerLabel: UILabel!
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            self.performSegue(withIdentifier: "Home->Login", sender: self)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).getDocument { (doc, err) in
            if err == nil{
                //print(doc?.data()!["email"] as! String)
                self.emailLabel.text = doc?.data()!["email"] as! String
                self.bannerLabel.text = doc?.data()!["banner"] as! String
            }
        }

        // Do any additional setup after loading the view.
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
