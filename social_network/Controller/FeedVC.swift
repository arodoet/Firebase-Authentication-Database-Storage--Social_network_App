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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker:UIImagePickerController!
    
    var posts:[Post] = []
    
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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
           
            //provera da li ima slike u kes memoriji
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
               
                cell.configureCell(post: post, image: image)
                return cell

                
            }else{
                cell.configureCell(post: post, image: nil)
                return cell

            }
            
        }else{
            return PostCell()
        }
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageAdd.image = image
        }
        else{
            print("Teodora: A valid image was not selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func signOutTapped(_ sender: Any) {       // moramo se odjaviti sa Firebase-a i skloniti user id iz keychain-a
    
        let result = KeychainWrapper.standard.removeObject(forKey: KEY_ID)
        print("ID removed from keychain: \(result)")
        
        try!Auth.auth().signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
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
