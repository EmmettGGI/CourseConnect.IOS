//
//  QuestionTableViewController.swift
//  CourseConnect
//
//  Created by Emmett Deen on 2/3/19.
//  Copyright © 2019 Emmett Deen. All rights reserved.
//

import UIKit
import Firebase

class QuestionTableViewController: UITableViewController {

    var question: DocumentSnapshot!
    var data = [String]()
    let uuid = "e20a39f4-73f5-4bc4-a12f-17d1ad07a965"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        data.append(question.data()!["question"] as! String)
        data.append("A: \(question.data()!["answerA"] as! String)")
        data.append("B: \(question.data()!["answerB"] as! String)")
        data.append("C: \(question.data()!["answerC"] as! String)")
        data.append("D: \(question.data()!["answerD"] as! String)")
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "Question", for: indexPath)
            cell.textLabel?.text = data[indexPath.row]
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "Answer", for: indexPath)
            cell.textLabel?.text = data[indexPath.row]
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
        }else{
        Firestore.firestore().collection("classes").document(self.uuid).collection("questions").document(self.question.documentID).collection("voters").document(Auth.auth().currentUser!.uid).setData(["time": "time"])
        
        if indexPath.row == 1{
            Firestore.firestore().collection("classes").document(self.uuid).collection("questions").document(self.question.documentID).collection("aVoters").document(Auth.auth().currentUser!.uid).setData(["time": "time"])
        }
        if indexPath.row == 2{
            Firestore.firestore().collection("classes").document(self.uuid).collection("questions").document(self.question.documentID).collection("bVoters").document(Auth.auth().currentUser!.uid).setData(["time": "time"])
        }
        if indexPath.row == 3{
            Firestore.firestore().collection("classes").document(self.uuid).collection("questions").document(self.question.documentID).collection("cVoters").document(Auth.auth().currentUser!.uid).setData(["time": "time"])
        }
        if indexPath.row == 4{
            Firestore.firestore().collection("classes").document(self.uuid).collection("questions").document(self.question.documentID).collection("dVoters").document(Auth.auth().currentUser!.uid).setData(["time": "time"])
        }
        
        self.performSegue(withIdentifier: "Question->Home", sender: self)
        }
    
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
