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
    
    var post:Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(post:Post){
        self.post = post
        
        caption.text = post.caption
        likesLbl.text = "\(post.likes)"
    }

}
