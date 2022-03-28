//
//  ToDoListModel+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Nisha Pillai on 28/03/22.
//
//

import Foundation
import CoreData


extension ToDoListModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListModel> {
        return NSFetchRequest<ToDoListModel>(entityName: "ToDoListModel")
    }

    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var segmentType: String?

}

extension ToDoListModel : Identifiable {

}
