//
//  TableViewCell.swift
//  PillReminder
//
//  Created by null on 4.12.2022.
//

import RealmSwift
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var pillName: UILabel!
    @IBOutlet weak var reminderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
