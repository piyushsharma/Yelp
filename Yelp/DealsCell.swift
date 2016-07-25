//
//  DealsCell.swift
//  Yelp
//
//  Created by Piyush Sharma on 7/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealsCellDelegate {
    optional func dealsCell(dealCell: DealsCell, didChangeValue value: Bool)
}

class DealsCell: UITableViewCell {
    
    @IBOutlet weak var dealsLabel: UILabel!
    @IBOutlet weak var dealsSwitch: UISwitch!
    
    weak var delegate: DealsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onDealsSwitchValueChanged(sender: AnyObject) {
        delegate?.dealsCell?(self, didChangeValue: dealsSwitch.on)        
    }
}
