//
//  ViewController.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/19/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let FACEBOOK_LOGIN = FBSDKLoginManager()
        
        FACEBOOK_LOGIN.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) in
            if error != nil{
                print("TEODORA:Unable to authenticate with Faceobook - \(String(describing: error))")
            }else if result?.isCancelled == true{
                print("TEODORA:User cancelled Facebook authentication")
            }else {
                print("TEODORA:Successfully authenticated with Facebook")
            }
            
            let CREDENTIAL = FacebookAuthProvider.credential(withAccessToken:FBSDKAccessToken.current().tokenString)
            
            firebaseAuth(CREDENTIAL)
            
        })
            
        func firebaseAuth(_ credential:AuthCredential){
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: {(user, error) in
                
                if error != nil{
                    print("TEODORA:Unable to authenticate with Firebase - \(String(describing: error))")
                }else {
                    print("TEODORA:Successfully authenticated with Firebase")
                }
            })
      
        }
        
        
    }
    
}

