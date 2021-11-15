//
//  CellPurchaseHistory.swift
//  BookManagement
//
//  Created by Rahul Pasi on 14/10/21.
//

import UIKit

class CellPurchaseHistory: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var bookNameLbl: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var shortDescriptionLbl: UILabel!
    @IBOutlet weak var pruchasedDateLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        outerView.layer.shadowOpacity = 0.2
        outerView.layer.shadowRadius = 4.0
        outerView.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
