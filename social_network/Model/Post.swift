//
//  Post.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/24/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _imageUrl:String!
    private var _caption:String!
    private var _likes:Int!
    private var _postKey:String!
    
    var postRef:DatabaseReference

    
    var imageUrl:String{
        return _imageUrl
    }
    var caption:String{
        return _caption
    }
    var likes:Int{
        return _likes
    }
    var postKey:String{
        return _postKey
    }
    
    
    // sta ce nam ovaj init ? ? ?
//    init(imageUrl:String, caption:String, likes:Int) {
//        _imageUrl = imageUrl
//        _caption = caption
//        _likes = likes
//    }
    
    init(postKey:String, postData:[String:Any]) {
        
        _postKey = postKey
        
        if let imageUrl = postData["imageUrl"] as? String {
            _imageUrl = imageUrl
        }
        if let caption = postData["caption"] as? String{
            _caption = caption
        }
        if let likes = postData["likes"] as? Int{
            _likes = likes
        }
        
        postRef = DataService.DS.ref_posts.child(_postKey)
    }
    
    
    func adjustLikes(addLike:Bool){
        if addLike {
            _likes = _likes + 1
        }else{
            _likes = _likes - 1
        }
        postRef.child("likes").setValue(_likes)
    }
    
}
