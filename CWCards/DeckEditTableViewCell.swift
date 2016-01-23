//
//  DeckEditTableViewCell.swift
//  CWCards
//
//  Created by mineharu on 2016/01/21.
//  Copyright © 2016年 Mineharu. All rights reserved.
//

import UIKit

class DeckEditTableViewCell: UITableViewCell {

    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardCountSegue: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
