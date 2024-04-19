//
//  itemCellTableViewCell.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/18/24.
//

import UIKit
protocol ItemCellDelegate: AnyObject {
    func stepperValueChanged(for cell: itemCellTableViewCell, newValue: Int)
}
class itemCellTableViewCell: UITableViewCell {

    @IBOutlet weak var stepperVal: UILabel!
    
    
    @IBOutlet weak var eachItemPrice: UILabel!
    
    
    @IBOutlet weak var itemName: UILabel!
    
  
    
    @IBAction func stepperBtn(_ sender: UIStepper){
        
    }
        
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var itemImg: UIImageView!
    
    weak var delegate: ItemCellDelegate?
        var cartItem: CartItem?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            stepper.minimumValue = 1
            stepper.stepValue = 1
            stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        }
        
        func configure(with item: CartItem) {
            cartItem = item
            itemName.text = item.name
            eachItemPrice.text = "$\(item.price * item.count)"
            stepperVal.text = "\(item.count)"
            if let url = URL(string: item.imgUrl) {
                itemImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
            stepper.value = Double(item.count)
        
        }
        
        @objc func stepperValueChanged(_ sender: UIStepper) {
            let newValue = Int(sender.value)
               stepperVal.text = "\(newValue)"

               delegate?.stepperValueChanged(for: self, newValue: newValue)
               cartItem?.count = newValue
               eachItemPrice.text = "$\(newValue * (cartItem?.price ?? 0))"
        }
    }
