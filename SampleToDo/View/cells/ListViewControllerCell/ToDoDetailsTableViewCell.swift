//
//  ToDoDetailsTableViewCell.swift
//  ToDoList
//
//  Created by Venkatesh Nyamagoudar on 2/26/23.
//

import UIKit
import CoreData

class ToDoDetailsTableViewCell: UITableViewCell {

    static var identifier = "MyCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ToDoDetailsTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    var list: List?
    
    // Custom setter so we can initialize the height of the text view
    var textString: String {
        get {
            return textView?.text ?? ""
        }
        set {
            if let textView = textView {
                textView.text = newValue
                textView.delegate?.textViewDidChange?(textView)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView?.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            textView?.becomeFirstResponder()
        } else {
            textView?.resignFirstResponder()
        }
    }
    
    func configure(with list: List) {
        self.list = list
        if list.isMarked {
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
        textView.text = list.text
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        guard let marked = list?.isMarked else {return}
        if marked {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
        list?.isMarked.toggle()
    }
}
