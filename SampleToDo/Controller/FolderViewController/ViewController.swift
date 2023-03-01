//
//  ViewController.swift
//  SampleToDo
//
//  Created by Venkatesh Nyamagoudar on 2/27/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = FolderViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "My To Do List"
        navigationController?.toolbar.isHidden = true
        navigationController?.toolbar.isTranslucent = true
        view.backgroundColor = .secondarySystemBackground
        navigationItem.rightBarButtonItem = editButtonItem
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.folderArray = viewModel.coreDataManager.fetchRequest(ofType: ToDoFolder.self)
        tableView.reloadData()
        
    }
    
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: ToDoListTableViewCell.identifier)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20.0
        tableView.backgroundColor = .systemBackground
    }

    @IBAction func newFolderButton(_ sender: Any) {
        presentAlertController()
    }
    
    func presentAlertController() {
        let alert = UIAlertController(title: "Add new List", message: "Type List name", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        let saveButton = UIAlertAction(title: "Save", style: .default) { save in
            if let text = alert.textFields?.first?.text {
                self.viewModel.createNewArrayElement(with: text)
                self.tableView.reloadData()
            }
        }
        saveButton.isEnabled = false
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notifyFolderName in
                if let folderName = textField.text, !folderName.isEmpty {
                    saveButton.isEnabled = true
                } else {
                    saveButton.isEnabled = false
                }
            }
        }
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.folderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.identifier, for: indexPath) as! ToDoListTableViewCell
        let object = viewModel.getObject(at: indexPath)
        cell.configure(with: object.title!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewToListController", sender: self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteFolder(at: indexPath)
            tableView.reloadData()
        }
    }
    
    
    /// Description: Set the ability of a row to move the cell from one row to another
    /// - Parameters:
    ///   - tableView: Editing TableView
    ///   - indexPath: indexPath from where the cell is being moved
    /// - Returns: return true if the cell can be moved else false
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    /// Description: Implementation of the cell movement from source to destination Indexpath
    /// - Parameters:
    ///   - tableView: Editing Tableview
    ///   - sourceIndexPath: Cell that is selected for moving
    ///   - destinationIndexPath: destination for the new cell
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.swap(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

//MARK: Navigation

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewToListController",
        let selectedIndex = tableView.indexPathForSelectedRow  {
            let destination = segue.destination as! ListViewController
            let object = viewModel.getObject(at: selectedIndex)
            destination.viewModel =
            ListViewControllerViewModel(
                folder: object,
                coreDataManager: viewModel.coreDataManager)
        }
    }
    
    
    
}

