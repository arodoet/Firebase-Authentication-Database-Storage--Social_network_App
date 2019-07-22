//
//  PostCell.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/22/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var heart: CircleView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
