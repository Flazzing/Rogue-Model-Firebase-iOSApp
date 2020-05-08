//
//  TaskViewCell.swift
//  GoingRogueDesign
//
//  Created by Cheng Lim on 4/4/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var resolvedButton: UIButton!
    
    func setTask(task: Task){
        
        taskName.text = task.taskname
        taskDueDate.text = task.taskdueDate
    }
    
    // Sets the resolve button's state when launch the task view
    func resolvedButtonStatus(status: String){
        if(status == "completed"){
            resolvedButton.isSelected = true
        }
        else{
            resolvedButton.isSelected = false
        }
    }
    
}
