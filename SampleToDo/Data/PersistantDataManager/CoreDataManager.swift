//
//  CoreDataManager.swift
//  SampleToDo
//
//  Created by Venkatesh Nyamagoudar on 2/27/23.
//

import Foundation
import CoreData

class CoreDataManager {

    //MARK: Core Data Set Up
    let persistantContainer: NSPersistentContainer
    
    init() {
        self.persistantContainer = NSPersistentContainer(name: "ToDoModel")
        self.load()
    }
    
    var viewContext: NSManagedObjectContext {
        return persistantContainer.viewContext
    }

    //used to call persistant containers loadPersistant function
    func load(completion handler: (() -> Void)? = nil ) {
        persistantContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Persistant Container not loaded. Error: \(String(describing: error))")
            }
        }
        handler?()
    }
    
    /// Description: To save the changes made
    func save() {
        do {
            try viewContext.save()
            print("viewContext saved")
        } catch let error {
            fatalError("Error while saving data. Error: \(error)")
        }
    }
    
    
    /// Description: Used to fetch data for folders
    /// - Parameter type: Type of data that is to be fetched
    /// - Returns: array of the type
    func fetchRequest<T: NSManagedObject>(ofType type: T.Type) -> [T] {
        let fetchrequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchrequest.sortDescriptors = [sortDescriptor]
        return try! viewContext.fetch(fetchrequest)
    }
    
    /// Description: Used to fetch lists for the selected folder
    /// - Parameters:
    ///   - type: Type of data that is to be fetched
    ///   - folder: Folder which contains the lists or selected folder
    /// - Returns: array of the type
    func fetchRequestUsingPredicate<T: NSManagedObject>(ofType type: T.Type, for folder: ToDoFolder) -> [T] {
        let fetchrequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        let predicate = NSPredicate(format: "folder == %@", folder)
        fetchrequest.predicate = predicate
        fetchrequest.sortDescriptors = [sortDescriptor]
        return try! viewContext.fetch(fetchrequest)
    }
}


//class FetchedResultsControllerManager<T: NSManagedObject> {
//    
//    var fetchedResultscontroller: NSFetchedResultsController<NSFetchRequestResult>?
//    var viewContext:
//    
//    init(keys: [String]) {
//        self.fetchedResultscontroller = setUpFetchedResultController(with: keys)
//        performFetch()
//    }
//    
//    func setUpFetchedResultController (with keys: [String], and predicate: NSPredicate? = nil) -> NSFetchedResultsController<NSFetchRequestResult>{
//        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
//            fatalError("Can't set up NSFetchRequest")
//        }
//        request.sortDescriptors = getSortDescriptor(for: keys)
//        request.predicate = predicate
//        return NSFetchedResultsController<T>(fetchRequest: request, managedObjectContext: , sectionNameKeyPath: nil, cacheName: nil)
//    }
//    
//    func performFetch() {
//        do {
//            try self.fetchedResultscontroller?.performFetch()
//        } catch let error {
//            fatalError("Error while initialising FetchedController. Error: \(error)")
//        }
//    }
//    
//    fileprivate func getSortDescriptor(for keys: [String]) -> [NSSortDescriptor] {
//        var sort = [NSSortDescriptor]()
//        for key in keys {
//            let tempSort = NSSortDescriptor(key: key, ascending: true)
//            sort.append(tempSort)
//        }
//        return sort
//    }
//}
