//
//  ListViewController.swift
//  SampleToDo
//
//  Created by Venkatesh Nyamagoudar on 2/27/23.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var activeTextView: UITextView!
    
    var viewModel : ListViewControllerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.lists = viewModel.coreDataManager.fetchRequestUsingPredicate(ofType: List.self, for: viewModel.folder)
        viewModel.fetchedResultController.delegate = self
        viewModel.performFetch()
        tableView.reloadData()
    }
    
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoDetailsTableViewCell.nib(), forCellReuseIdentifier: ToDoDetailsTableViewCell.identifier)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20.0
        tableView.separatorColor = .systemBackground
    }
    
    @IBAction func newListButtonTapped(_ sender: Any) {
        viewModel.createNewList()
        tableView.reloadData()
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchedResultController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoDetailsTableViewCell.identifier, for: indexPath) as! ToDoDetailsTableViewCell
        let list = viewModel.fetchedResultController.object(at: indexPath)
        cell.configure(with: list)
        cell.textView.delegate = self
        cell.textView.tag = indexPath.row
        return cell
    }
}

extension ListViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            let indexPath = NSIndexPath(row: textView.tag, section: 0) as IndexPath
            let list = viewModel.fetchedResultController.object(at: indexPath)
            list.text = textView.text
        }
        viewModel.coreDataManager.save()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        //set height as max CGFloat value
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        //resize the cell size if there is a change in textview size
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            let thisIndexPath = NSIndexPath(row: textView.tag, section: 0)
            tableView.scrollToRow(at: thisIndexPath as IndexPath, at: .bottom, animated: false)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //if you hit "Enter" you resign first responder
        //and don't put this character into text view text
        if textView.text == "" {
            if let char = text.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    if let indexPath = tableView.indexPathForSelectedRow {
                        self.viewModel.deleteList(at: indexPath)
                    }
                    textView.resignFirstResponder()
                    tableView.reloadData()
                    return false
                }
            }
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


extension ListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
                viewModel.coreDataManager.save()
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        case .move:
            print("Not written yet")
            break
        case .update:
            print("Not written yet")
            break
        @unknown default:
            tableView.reloadData()
            fatalError()
        }
    }
}
