//
//  PostCell.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/22/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var likeImg: CircleView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post:Post!
    
    var likesRef:DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        tap.isEnabled = true      // kod njega je tap.isUserInteractionEnabled = true. ja sam u inter.builder-u obelezila
        
    }
    
    func configureCell(post:Post, image:UIImage?){
        self.post = post
        
        caption.text = post.caption
        likesLbl.text = "\(post.likes)"
        
        likesRef = DataService.DS.ref_user_current.child("likes").child(post.postKey)
    
        if image != nil {
            self.postImg.image = image
        }else{
            
            let REF = Storage.storage().reference(forURL: post.imageUrl)
            REF.getData(maxSize: 2*1024*1024) { (data, error) in
                
                if error != nil{
                    print("Teodora: Unable to download image from firebase storage")
                }else{
                    print("Teodora: Successfully downloaded image from firebase storage")
                    if let imageData = data{
                        if let image = UIImage(data: imageData){
                            self.postImg.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)  // kesiramo sliku
                        }
                    }
                }
                
            }
        }
        
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImg.image = UIImage(named: "empty-heart")
            }else{
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        }
    }
    
    @objc func likeTapped( _ sender:UITapGestureRecognizer){
        
        likesRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            }else{
                
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        }
    }

}
