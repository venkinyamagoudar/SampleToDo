//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Venkatesh Nyamagoudar on 2/19/23.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell {

    static let identifier = "ToDoListTableViewCell"
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        self.accessoryType = .disclosureIndicator
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 20, y: 10, width: 200, height: 30)
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
