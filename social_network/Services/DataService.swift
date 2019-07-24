//
//  DataService.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/24/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import Foundation
import Firebase

let REF = Database.database().reference()

class DataService{
    
    static let DS = DataService()
    private init(){}
    
    
    private var _ref_base = REF
    private var _ref_posts = REF.child("posts")
    private var _ref_users = REF.child("users")
    
    var ref_base:DatabaseReference{
        return _ref_base
    }
    var ref_posts:DatabaseReference{
        return _ref_posts
    }
    var ref_users:DatabaseReference{
        return _ref_users
    }
    
    
    func createFirebaseDBUser(uid:String,userData:[String:String] ) {
        
        ref_users.child(uid).updateChildValues(userData)   // DODACE nove vrednosti ( NE OVERWRITE!! )
        
    }
    
    
}
