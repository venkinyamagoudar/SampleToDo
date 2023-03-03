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
    var fetchedResultController: NSFetchedResultsController<List>!
    
    init(folder: ToDoFolder!, coreDataManager: CoreDataManager!) {
        self.folder = folder
        self.coreDataManager = coreDataManager
        fetchedResultController = setUpFetchedResultController()
    }
    
    func getObject(at indexPath: IndexPath) -> List {
        return lists[indexPath.row]
    }
    
    func getObject(at indexPath: Int) -> List {
        return lists[indexPath]
    }
    
    func setUpFetchedResultController() -> NSFetchedResultsController<List> {
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let predicate = NSPredicate(format: "folder == %@", folder)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func performFetch() {
        do {
            try fetchedResultController?.performFetch()
        } catch let error {
            fatalError("Error while initialising FetchedController. Error: \(error)")
        }
    }
    
    func createNewList() {
        let newList = List(context: coreDataManager.viewContext)
        newList.text = ""
        newList.creationDate = Date()
        newList.isMarked = false
        newList.folder = folder
        coreDataManager.save()
//        lists.append(newList)
    }
    
    func deleteList(at indexPath: IndexPath) {
        let rowToBeDeleted = fetchedResultController.object(at: indexPath)
        coreDataManager.viewContext.delete(rowToBeDeleted)
        
//        lists.remove(at: row)
        coreDataManager.save()
    }
}
