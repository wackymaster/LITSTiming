//
//  ClassTableViewCell.swift
//  Steer
//
//  Created by Mac Sierra on 12/28/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit
import SQLite3

class EventTableViewCell: UITableViewCell {
    var db: OpaquePointer?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var splitsURL: UILabel!
    @IBOutlet weak var streamURL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    


    
}
