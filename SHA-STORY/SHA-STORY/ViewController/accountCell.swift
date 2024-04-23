//
//  accountCell.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/23/24.
//

import UIKit

class accountCell: UITableViewCell {

    @IBOutlet weak var first: UILabel!
    
    @IBOutlet weak var second: UILabel!
    
    @IBOutlet weak var third: UILabel!
    
    @IBOutlet weak var fourth: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
