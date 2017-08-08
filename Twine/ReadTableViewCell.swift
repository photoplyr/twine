//
//  ReadTableViewCell.swift
//  Twine
//
//  Created by troy simon on 8/2/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//

import UIKit

class ReadTableViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.header.text = ""
        self.from.text = ""
        self.message.text = ""
        self.date.text = ""
    }
 
    
    //"\(readEmail.object(forKey: "subject") ?? "")"
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
