//
//  ProjectsViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/23/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import Firebase

class ProjectsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createProjectArray()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // Go through the list of projects from the DB and retrieve projects based on "customerEmail"
    func createProjectArray(){
        let documentEmail = Auth.auth().currentUser!.email
        let db = Firestore.firestore().collection("Project")
        
        db.getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in QuerySnapshot!.documents{
                    if (documentEmail == document.get("customerEmail") as? String){
  
                        // Guarding the force unwrap to avoid program crashing
//                        guard document.get("projectStartDate") != nil else{
//                            print("No valid date")
//                            return
//                        }
                        
                        let timeStamp = document.get("projectStartDate") as! Timestamp
                        let dateString = self.dateConvertToString(date: timeStamp.dateValue())
                       
                        let _Project = Project(title: document.get("projectName") as? String ?? "N/A", address: document.get("projectAddress") as? String ?? "N/A", status: document.get("projectType") as? String ?? "N/A", startDate: dateString, description: document.get("projectDescription") as? String ?? "N/A")
                        
                        self.projects.append(_Project)
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    // Takes the time stamp and convert to date
    func dateConvertToString(date: Date) -> String{
        let df = DateFormatter()
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        df.dateFormat = "yyyy-MM-dd' at 'hh:mm a"
        return df.string(from: date)
    }

}

// For UITable view extension
extension ProjectsViewController: UITableViewDataSource, UITableViewDelegate{
        
    // Determine how many rows should table view actually show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    // Configuring each and every project cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell") as! ProjectsViewCell
        
        cell.setProject(project: project)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowProjectDetail", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // Pass data through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowProjectDetail"{
            if let vc = segue.destination as? ProjectDetailViewController{
                let row = self.tableView.indexPathForSelectedRow!.row
                vc.project = projects[row]
            }
        }
    }
}