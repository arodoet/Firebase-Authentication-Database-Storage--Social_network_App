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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_ID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
            
            self.firebaseAuth(CREDENTIAL)
            
        })
    }
    
    func firebaseAuth(_ credential:AuthCredential){
        
        
        Auth.auth().signInAndRetrieveData(with: credential, completion: {(user, error) in

            if error != nil{
                print("TEODORA:Unable to authenticate with Firebase - \(String(describing: error))")
            }else {
                print("TEODORA:Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider":credential.provider]
                    self.completeSignIn(id:user.user.uid, userData: userData)
                }
            }
        })
        
    }
    
    func completeSignIn(id:String, userData:[String:String]){
        DataService.DS.createFirebaseDBUser(uid: id, userData: userData)
        let result = KeychainWrapper.standard.set(id, forKey: KEY_ID)
        print("Data saved to keychain: \(result)")
        self.performSegue(withIdentifier: "goToFeed", sender: nil)
    }
        
        
    
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text{
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion:{(user,error) in
                
                if error == nil{
                    print("Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider":user.user.providerID]
                        self.completeSignIn(id: user.user.uid,userData: userData)
                    }
                }else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user, error)in
                        if error != nil{
                            print("Unable to auth with Firebase using email")
                        }else{
                            print("Successfully auth with Firebase using email")
                            if let user = user{
                                let userData = ["provider":user.user.providerID]
                                self.completeSignIn(id: user.user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
}

