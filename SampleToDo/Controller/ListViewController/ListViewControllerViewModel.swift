//
//  ListViewControllerViewModel.swift
//  SampleToDo
//
//  Created by Venkatesh Nyamagoudar on 2/27/23.
//

import Foundation
import CoreData

class ListViewControllerViewModel {
    var folder: ToDoFolder
    var lists:[List]!
    var coreDataManager: CoreDataManager
    
    init(folder: ToDoFolder!, coreDataManager: CoreDataManager!) {
        self.folder = folder
        self.coreDataManager = coreDataManager
    }
    
    func getObject(at indexPath: IndexPath) -> List {
        return lists[indexPath.row]
    }
    
    func getObject(at indexPath: Int) -> List {
        return lists[indexPath]
    }
    
    func createNewList() {
        let newList = List(context: coreDataManager.viewContext)
        newList.text = ""
        newList.creationDate = Date()
        newList.isMarked = false
        newList.folder = folder
        coreDataManager.save()
        lists.append(newList)
    }
    
    func deleteList(at row: Int) {
        let rowToBeDeleted = lists[row]
        coreDataManager.viewContext.delete(rowToBeDeleted)
        lists.remove(at: row)
        coreDataManager.save()
    }
}
