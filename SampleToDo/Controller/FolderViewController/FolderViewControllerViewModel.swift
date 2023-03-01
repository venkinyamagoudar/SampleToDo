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
    var folderArray = [ToDoFolder]()

    func getObject(at indexPath: IndexPath) -> ToDoFolder {
        return folderArray[indexPath.row]
    }
    
    func swap(from source: Int, to destination: Int) {
        self.folderArray.swapAt(source,destination)
//        coreDataManager.save()
    }
    
    func createNewArrayElement(with text: String) {
        let newFolder = ToDoFolder(context: coreDataManager.viewContext)
        newFolder.title = text
        newFolder.creationDate = Date()
        newFolder.arrayOfList = []
        coreDataManager.save()
        folderArray.append(newFolder)
    }
    
    func deleteFolder(at indexPath: IndexPath) {
        let folderToBeDeleted = folderArray[indexPath.row]
        coreDataManager.viewContext.delete(folderToBeDeleted)
        folderArray.remove(at: indexPath.row)
        coreDataManager.save()
    }
}
