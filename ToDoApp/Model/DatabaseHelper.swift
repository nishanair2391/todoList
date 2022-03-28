//
//  DatabaseHelper.swift
//  ToDoApp
//
//  Created by Nisha Pillai on 28/03/22.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper{
    
    static var shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: Helper Func for Core Data
    func getTaskList(index : Int)->[ToDoListModel]{

        var filteredArray = [ToDoListModel]()
        let filter = self.getSegmentString(index: index)
        
        let predicate = NSPredicate(format: "segmentType = %@", filter)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ToDoListModel")
        fetchRequest.predicate = predicate
                            
        do{
            let fetchedResults = try context.fetch(fetchRequest) //as! [NSManagedObject]
            print("Fetch results")
            for i in 0..<fetchedResults.count{
                let task = fetchedResults[i] as! ToDoListModel
                print(task)
                filteredArray.append(task)
            }
            return filteredArray
                                                  
        }catch let err{
            print("Error",err)
        }

        return []
    }
    
    
    func getSegmentString(index : Int)-> String{
        switch index{
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        case 2:
            return "Upcoming"
        default : return "Today"
        }
    }
    
    func saveTask(taskTitle: String, taskDescription : String?, segmentIndex : Int){
        let taskData = ToDoListModel(context: context)
        taskData.taskTitle = taskTitle
        taskData.taskDescription = taskDescription ?? ""
        taskData.segmentType = self.getSegmentString(index: segmentIndex)
        do {
            try context.save()
//            self.getTaskList(index: segmentIndex)
        }catch{
            //error
        }
    }
    
    func deleteTaskData(model: ToDoListModel){
        context.delete(model)
        do {
            try context.save()
//            self.getTaskList(index: selectedIndex)
        }catch{
            //error
        }
    }
    func updateTaskList(model : ToDoListModel, newTaskTitle : String, newTaskDescription : String?){
        model.taskTitle = newTaskTitle
        model.taskDescription = newTaskDescription ?? ""
    
        do {
            try context.save()
//            self.getTaskList(index: selectedIndex)
        }catch{
            //error
        }
        
    }
    
}
