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
    
    var QDoc: DocumentSnapshot!
    
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
            
            Firestore.firestore().collection("classes").document("TestBeacon").collection("questions").addSnapshotListener({ (snaps, err) in
                snaps?.documents.forEach({ (doc) in
                    if doc.data()["start"] as! String != "none"{
                        
                        doc.reference.collection("voters").document((Auth.auth().currentUser?.uid)!).getDocument(completion: { (d, e) in
                            if e == nil && !(d?.exists)!{
                                self.QDoc = doc
                                self.performSegue(withIdentifier: "Home->Question", sender: self)
                            }
                        })
                    }
                })
            })
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! QuestionTableViewController
        dest.question = self.QDoc
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
