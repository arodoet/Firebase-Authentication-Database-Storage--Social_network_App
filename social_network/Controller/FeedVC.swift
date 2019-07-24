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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.DS.ref_posts.observe(DataEventType.value) { (snapshot) in
           
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let postData = snap.value as? [String:Any]{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postData)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            cell.configureCell(post: post)
            return cell
        }else{
            return PostCell()
        }
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
