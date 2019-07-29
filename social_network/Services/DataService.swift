//
//  DataService.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/24/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

class DataService{
    
    static let DS = DataService()
    private init(){}
    
    
    private var _ref_base = REF
    private var _ref_posts = REF.child("posts")
    private var _ref_users = REF.child("users")
    
    private var _ref_post_images = STORAGE_REF.child("post-pics")
    
    
    //vraca mi trenutnog korisnika:
    var ref_user_current:DatabaseReference{
        // posto se id user-a u Keychain-u podudara sa id-jem usera u bazi to cemo iskoristiti
        guard let uid = KeychainWrapper.standard.string(forKey: KEY_ID) else { return DatabaseReference()}
        let user = DataService.DS._ref_users.child(uid)
        return user
    }
    
    var ref_base:DatabaseReference{
        return _ref_base
    }
    var ref_posts:DatabaseReference{
        return _ref_posts
    }
    var ref_users:DatabaseReference{
        return _ref_users
    }
    
    var ref_post_images:StorageReference{
        return _ref_post_images
    }
    
    
    func createFirebaseDBUser(uid:String,userData:[String:String] ) {
        
        ref_users.child(uid).updateChildValues(userData)   // DODACE nove vrednosti ( NE OVERWRITE!! )
        
    }
    
    
}
