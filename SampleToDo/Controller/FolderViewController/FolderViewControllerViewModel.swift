//
//  FolderViewControllerViewModel.swift
//  SampleToDo
//
//  Created by Venkatesh Nyamagoudar on 2/27/23.
//

import Foundation
import CoreData

class FolderViewControllerViewModel {
    //CoreDataManager object should not be created in viewModel
    var coreDataManager: CoreDataManager = CoreDataManager()
//    var folderArray = [ToDoFolder]()
    var fetchedResultController: NSFetchedResultsController<ToDoFolder>!
    
    init() {
        fetchedResultController = setUpFetchedResultController()
    }
    
    
    func swap(from source: Int, to destination: Int) {
//        self.folderArray.swapAt(source,destination)
//        coreDataManager.save()
    }
    
    func createNewArrayElement(with text: String) {
        let newFolder = ToDoFolder(context: coreDataManager.viewContext)
        newFolder.title = text
        newFolder.creationDate = Date()
        newFolder.arrayOfList = []
        coreDataManager.save()
//        folderArray.append(newFolder)
    }
    
    func deleteFolder(at indexPath: IndexPath) {
        if let folderToBeDeleted = fetchedResultController?.object(at: indexPath) {
            coreDataManager.viewContext.delete(folderToBeDeleted)
        }
//        folderArray.remove(at: indexPath.row)
        coreDataManager.save()
    }
    
    func setUpFetchedResultController() -> NSFetchedResultsController<ToDoFolder> {
        let fetchRequest: NSFetchRequest<ToDoFolder> = ToDoFolder.fetchRequest()
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:coreDataManager.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func performFetch() {
        do {
            try fetchedResultController?.performFetch()
        } catch let error {
            fatalError("Error while initialising FetchedController. Error: \(error)")
        }
    }
}
