//
//  FoodCategoryCell.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/16/24.
//

import UIKit

class FoodCategoryCell: UICollectionViewCell {

    @IBOutlet weak var foodItem: UILabel!
    
    @IBOutlet weak var foodPicture: UIImageView!
    
    
    @IBOutlet weak var foodPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
