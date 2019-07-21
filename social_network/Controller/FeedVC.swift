//
//  FeedVC.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/22/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutTapped(_ sender: Any) {       // moramo se odjaviti sa Firebase-a i skloniti user id iz keychain-a
    
        let result = KeychainWrapper.standard.removeObject(forKey: KEY_ID)
        print("ID removed from keychain: \(result)")
        
        try!Auth.auth().signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
