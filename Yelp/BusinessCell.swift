//
//  BusinessCell.swift
//  Yelp
//
//  Created by Piyush Sharma on 7/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var ratingsImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.nameLabel.text = self.business.name
            self.thumbImageView.setImageWithURL(self.business.imageURL!)
            self.ratingsImageView.setImageWithURL(self.business.ratingImageURL!)
            self.addressLabel.text = self.business.address
            self.ratingsCountLabel.text = "\(self.business.reviewCount!) Reviews"
            self.categoriesLabel.text = self.business.categories
            self.distanceLabel.text = self.business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.thumbImageView.layer.cornerRadius = 3
        self.thumbImageView.clipsToBounds = true
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
