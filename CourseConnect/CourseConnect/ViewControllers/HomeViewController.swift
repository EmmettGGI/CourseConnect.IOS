//
//  HomeViewController.swift
//  CourseConnect
//
//  Created by Emmett Deen on 2/2/19.
//  Copyright © 2019 Emmett Deen. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var QDoc: DocumentSnapshot!
    let uuid = "e20a39f4-73f5-4bc4-a12f-17d1ad07a965"
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
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
        
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).updateData(["push": Messaging.messaging().fcmToken])
       
        
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).getDocument { (doc, err) in
            if err == nil{
                //print(doc?.data()!["email"] as! String)
                self.emailLabel.text = doc?.data()!["email"] as! String
                self.bannerLabel.text = doc?.data()!["banner"] as! String
            }
            
            Firestore.firestore().collection("classes").document(self.uuid).collection("questions").addSnapshotListener({ (snaps, err) in
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
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        if let uuid = UUID(uuidString: self.uuid) {
            let beaconRegion = CLBeaconRegion(
                proximityUUID: uuid,
                major: 0,
                minor: 0,
                identifier: "iBeacon")
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
            print("Start Monitoring")
        }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! QuestionTableViewController
        dest.question = self.QDoc
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID ENTER REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
            
            Firestore.firestore().collection("classes").document(beaconRegion.proximityUUID.uuidString).collection("users").document((Auth.auth().currentUser?.email)!).updateData(["isAttending": true])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
            Firestore.firestore().collection("classes").document(beaconRegion.proximityUUID.uuidString).collection("users").document((Auth.auth().currentUser?.email)!).updateData(["isAttending": false])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            var beaconProximity: String;
            
            
            switch (beacon.proximity) {
            case .unknown:
               print("unknown")
               //Firestore.firestore().collection("classes").document(self.uuid).collection("students").document((Auth.auth().currentUser?.email)!).updateData(["isAttending": false])
            case .immediate:
               print("immediate")
               Firestore.firestore().collection("classes").document(self.uuid).collection("students").document((Auth.auth().currentUser?.email)!).updateData(["isAttending": true])
                distanceLabel.text = "Immediate"
            case .near:
               print("near")
               Firestore.firestore().collection("classes").document(self.uuid).collection("students").document((Auth.auth().currentUser?.email)!).updateData(["isAttending": true])
                distanceLabel.text = "Near"
            case .far:
               print("far")
               Firestore.firestore().collection("classes").document(self.uuid).collection("students").document((Auth.auth().currentUser?.email)!).updateData(["isAttending": false])
                distanceLabel.text = "Far"
            }
            //print("BEACON RANGED: uuid: \(beacon.proximityUUID.UUIDString) major: \(beacon.major)  minor: \(beacon.minor) proximity: \(beaconProximity)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
