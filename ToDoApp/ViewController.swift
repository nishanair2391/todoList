//
//  ViewController.swift
//  ToDoApp
//
//  Created by Nisha Pillai on 27/03/22.
//

import UIKit
import CoreData

enum TaskType{
    case Today
    case Tomorrow
    case Upcoming
}

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var segmentControl : UISegmentedControl!
    
    private var selectedSegmentIndex : Int = 0
    private var toDoListModels = [ToDoListModel]()
    private var filteredArray = [ToDoListModel]()
    
    //MARK: View Controller Methodsa
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
        
    }
    func setUpUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        self.getTaskList()
    }
    func getTaskList(){
        if let value = UserDefaults.standard.value(forKey: "TaskType") as? Int{
            selectedSegmentIndex = value
            segmentControl.selectedSegmentIndex = selectedSegmentIndex
        }
        toDoListModels = DatabaseHelper.shareInstance.getTaskList(index: selectedSegmentIndex)
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
   @objc private func addButtonClicked(){
       self.createUIAlert(alertTitle: "New Task", alertMessage: "Create a New Task", alertActionButtion: "Submit", selectedModel: nil)
    }
  
    @IBAction func segmentChangeAction(_ sender: UISegmentedControl) {

        UserDefaults.standard.setValue(sender.selectedSegmentIndex, forKey: "TaskType")
        UserDefaults.standard.synchronize()
        
        self.getTaskList()
    }
    func createUIAlert(alertTitle : String , alertMessage: String, alertActionButtion : String, selectedModel: ToDoListModel? ){

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        if alertActionButtion == "Update"{
            alert.addTextField { taskTitleTextField in
                taskTitleTextField.placeholder = "Task Title"
                taskTitleTextField.text = selectedModel?.taskTitle
            }
            alert.addTextField { taskDescriptionTxtField in
                taskDescriptionTxtField.placeholder = "Task Description"
                taskDescriptionTxtField.text = selectedModel?.taskDescription
            }
        }else{
            alert.addTextField { taskTitleTextField in
                taskTitleTextField.placeholder = "Task Title"
            }
            alert.addTextField { taskDescriptionTxtField in
                taskDescriptionTxtField.placeholder = "Task Description"
            }
        }
        alert.addAction(UIAlertAction(title: alertActionButtion, style: .cancel, handler: { [weak self] _ in
            
            guard let taskTitleTxtfield = alert.textFields?.first, let taskTitle = taskTitleTxtfield.text, !taskTitle.isEmpty else {
                return
            }
            guard let taskDescTxtfield = alert.textFields?.last, let taskDesc = taskDescTxtfield.text else {
                return
            }
            if alertActionButtion == "Update"{
                DatabaseHelper.shareInstance.updateTaskList(model: selectedModel!, newTaskTitle: taskTitle, newTaskDescription: taskDesc)

            }else {
                
                
                DatabaseHelper.shareInstance.saveTask(taskTitle: taskTitle, taskDescription: taskDesc, segmentIndex: self?.segmentControl.selectedSegmentIndex ?? 0)
            }
            self?.getTaskList()
        }))
        self.present(alert, animated: true)
    }
  
}
//MARK: UITABLEVIEWDATASOURCE AND DELEGATE METHODS
extension ViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = toDoListModels[indexPath.row].taskTitle
        cell.detailTextLabel?.text = toDoListModels[indexPath.row].taskDescription
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedModel = toDoListModels[indexPath.row]
        let actionSheet = UIAlertController(title: "Alert", message: "Update or Delete your Task", preferredStyle: .actionSheet)
      
        actionSheet.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            self.createUIAlert(alertTitle: "Update Task", alertMessage: "Update Task", alertActionButtion: "Update", selectedModel: selectedModel)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            DatabaseHelper.shareInstance.deleteTaskData(model: selectedModel)
            self.getTaskList()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true)
    }
}

            
