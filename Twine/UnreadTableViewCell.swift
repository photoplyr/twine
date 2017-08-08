//
//  UnreadTableViewCell.swift
//  Twine
//
//  Created by troy simon on 8/2/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//

import UIKit

class UnreadTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func prepareForReuse() {
        self.collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
