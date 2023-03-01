//
//  ListViewController.swift
//  SampleToDo
//
//  Created by Venkatesh Nyamagoudar on 2/27/23.
//

import UIKit

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
        viewModel.lists = viewModel.coreDataManager.fetchRequestUsingPredicate(ofType: List.self, for: viewModel.folder)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoDetailsTableViewCell.identifier, for: indexPath) as! ToDoDetailsTableViewCell
        let list = viewModel.getObject(at: indexPath)
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
            let list = viewModel.getObject(at: activeTextView.tag)
            list.text = activeTextView.text
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
                    self.viewModel.deleteList(at: textView.tag)
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
