//
//  FeedCell.swift
//  FotografPaylasmaApp
//
//  Created by Bora Gündoğu on 7.04.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var yorumText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
