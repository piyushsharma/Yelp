//
//  CategoriesCell.swift
//  Yelp
//
//  Created by Piyush Sharma on 7/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol CategoriesCellDelegate {
    optional func categoriesCell(categoriesCell: CategoriesCell, didChangeValue value: Bool)
}

class CategoriesCell: UITableViewCell {

    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var categoriesSwitch: UISwitch!
    
    weak var delegate: CategoriesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func categorySwitchValueChanged(sender: AnyObject) {
          delegate?.categoriesCell?(self, didChangeValue: self.categoriesSwitch.on)
    }    
}
